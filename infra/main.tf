terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "1.13.1"
    }
  }
}

provider "random" {
  # Configuration options
}
provider "azapi" {
  # Configuration options
}
provider "azurerm" {
  features {

  }
}
locals {
  abbreviations_json            = file("${path.module}/abbreviations.json")
  abbrs                         = jsondecode(local.abbreviations_json)
  tags                          = { azd-env-name : var.environment_name }
}
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
resource "random_string" "rand" {
  length  = 6
  special = false
  lower   = true
  upper   = false
  numeric = false
}
resource "random_password" "sql_admin_password" {
  length           = 16
  special          = true
  override_special = "!$#%"
}
resource "random_password" "app_user_password" {
  length           = 16
  special          = true
  override_special = "!$#%"
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name != "" ? var.resource_group_name : "${local.abbrs.resourcesResourceGroups}${var.environment_name}"
  location = var.location
  tags = local.tags
}

// The application frontend
module "web" {
  source              = "./core/host/staticwebapp"
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.web_service_name != "" ? var.web_service_name : "${local.abbrs.webStaticSites}web-${random_string.rand.result}"
  location            = var.location
  tags               = merge(local.tags, { azd-service-name : "web" })
}
// The application backend
module "api"{
  source="./core/host/functions"
  resource_group_name = azurerm_resource_group.rg.name
  name = var.api_service_name != "" ? var.api_service_name : "${local.abbrs.webSitesFunctions}api-${random_string.rand.result}"
  location = var.location
  application_insights_name = module.monitoring.application_insights_name
  app_service_plan_id = module.app_service_plan.id
  key_vault_name = module.keyvault.name
  storage_account_name = module.storage.name
  allowed_origins = [ module.web.uri ]
  app_settings = {
      AZURE_SQL_CONNECTION_STRING_KEY = module.sql_server.connection_string_key
    }
  runtime_name = "dotnet-isolated"
  runtime_version = "8.0"
  tags               = merge(local.tags, { "azd-service-name" : "api" })
}
// Give the API access to KeyVault
module "api_keyvault_access" {
  source = "./core/security/keyvault-access"
  resource_group_name = azurerm_resource_group.rg.name
  key_vault_name = module.keyvault.name
  principal_id = module.api.identityPrincipalId
}

resource "azurerm_key_vault_secret" "sqlAdminPasswordSecret" {
  name         = "sqlAdminPassword"
  value        = random_password.sql_admin_password.result
  key_vault_id = module.keyvault.id
  depends_on = [ module.api_keyvault_access ]
}
resource "azurerm_key_vault_secret" "appUserPasswordSecret" {
  name         = "appUserPassword"
  value        = random_password.app_user_password.result
  key_vault_id = module.keyvault.id
  depends_on = [ module.api_keyvault_access ]
}
resource "azurerm_key_vault_secret" "sqlAzureConnectionStringSercret" {
  name         = module.sql_server.connection_string_key
  //value        = "Server=${sqlServer.properties.fullyQualifiedDomainName}; Database=${sqlServer::database.name}; User=${var.app_user}; Password=${var.sql_user_password}"
  value = "Server=tcp:${module.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${module.sql_server.databaseName};Persist Security Info=False;User ID=${module.sql_server.administrator_login};Password=${module.sql_server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = module.keyvault.id
  depends_on = [ module.api_keyvault_access ]
}

// The application database
module "sql_server"{
  source = "./core/database/sqlserver"
  resource_group_name = azurerm_resource_group.rg.name
  name = var.sql_server_name != "" ? var.sql_server_name : "${local.abbrs.sqlServers}${random_string.rand.result}"
  location = var.location
  database_name = var.sql_database_name
  sql_admin_password = random_password.sql_admin_password.result
  sql_user_password = random_password.app_user_password.result
  key_vault_name = module.keyvault.name
  tags           = azurerm_resource_group.rg.tags
}
// Create an App Service Plan to group applications under the same payment plan and SKU
module "app_service_plan"{
  source = "./core/host/appserviceplan"
  resource_group_name = azurerm_resource_group.rg.name
  name = var.app_service_plan_name != "" ? var.app_service_plan_name : "${local.abbrs.webServerFarms}${random_string.rand.result}"
  location = var.location
  reserved = true
  sku = {
      size = "Y1"
      tier = "Dynamic"
    }
  kind = "Linux"
  tags           = azurerm_resource_group.rg.tags
}
// Backing storage for Azure functions backend API
module "storage" {
  source              = "./core/storage/storageaccount"
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.storage_account_name != "" ? var.storage_account_name : "${local.abbrs.storageStorageAccounts}${random_string.rand.result}"
  location            = var.location
  tags                = azurerm_resource_group.rg.tags
}
// Store secrets in a keyvault
module "keyvault" {
  source              = "./core/security/keyvault"
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.key_vault_name != "" ? var.key_vault_name : "${local.abbrs.keyVaultVaults}${random_string.rand.result}"
  location            = var.location
  principal_id        = var.principal_id
  tags             = azurerm_resource_group.rg.tags
}
// Monitor application with Azure Monitor
module "monitoring" {
  source              = "./core/monitor/monitoring"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  log_analytics_name = var.log_analytics_name != "" ? var.log_analytics_name : "${local.abbrs.operationalInsightsWorkspaces}${random_string.rand.result}"
  application_insights_dashboard_name = var.application_insights_dashboard_name != "" ? var.application_insights_dashboard_name : "${local.abbrs.portalDashboards}${random_string.rand.result}"
  application_insights_name = var.application_insights_name != "" ? var.application_insights_name : "${local.abbrs.insightsComponents}${random_string.rand.result}"
  tags             = azurerm_resource_group.rg.tags
}
// Creates Azure API Management (APIM) service to mediate the requests between the frontend and the backend API
module "apim" {
  count               = var.use_apim ? 1 : 0
  source              = "./core/gateway/apim"
  resource_group_name = azurerm_resource_group.rg.name
  name                = var.api_service_name != "" ? var.api_service_name : "${local.abbrs.apiManagementService}${random_string.rand.result}"
  location            = var.location
  application_insights_name = module.monitoring.application_insights_name
  tags                      = merge(local.tags, { "azd-service-name" : var.environment_name })
}
// Configures the API in the Azure API Management (APIM) service
//TO-Do
module "apimApi" {
  count                    = var.use_apim ? 1 : 0
  source                   = "./core/gateway/apim-api"
  name                     = module.apim[0].apim_service_name
  resource_group_name      = azurerm_resource_group.rg.name
  web_front_end_url        = module.web.uri
  api_management_logger_id = module.apim[0].api_management_logger_id
  api_name                 = "todo-api"
  api_display_name         = "Simple Todo API"
  api_path                 = "todo"
  api_backend_url          = module.api.uri
}






