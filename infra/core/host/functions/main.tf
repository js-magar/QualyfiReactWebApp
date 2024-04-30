//Creates an Azure Function in an existing Azure App Service plan.
terraform {
  required_providers {
    azurerm = {
      version = "3.95.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      source = "Azure/azapi"
      version = "1.13.1"
    }
  }
}
provider "azapi" {
  # Configuration options
}
data "azurerm_storage_account" "storage" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}
data "azurerm_application_insights" "app_insights" {
  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
/*
locals {
  linux_fx_version = "${var.runtime_name}|${var.runtime_version}"
  managed_identity = length(var.key_vault_name) > 0
}
*/
resource "azurerm_linux_function_app" "functions" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id
  https_only          = true
  storage_account_name = data.azurerm_storage_account.storage.name
  storage_account_access_key = data.azurerm_storage_account.storage.primary_access_key
  tags                = var.tags
  site_config {
    //always_on         = var.always_on
    use_32_bit_worker = var.use_32_bit_worker_process
    ftps_state        = "FtpsOnly"
    app_command_line  = var.app_command_line
    cors {
        allowed_origins= setunion([ "https://portal.azure.com", "https://ms.portal.azure.com" ], var.allowed_origins)
      }
    application_stack {
      //node_version = var.node_version
      dotnet_version = var.runtime_version
    }
    minimum_tls_version =  "1.2"
    health_check_path = var.health_check_path
    app_service_logs {
      disk_quota_mb = 35
      retention_period_days = 1
    }
    
  }

  app_settings = merge( var.app_settings,
      {
        SCM_DO_BUILD_DURING_DEPLOYMENT = tostring(var.scm_do_build_during_deployment)
        ENABLE_ORYX_BUILD = tostring(var.enable_oryx_build)
      },
      {
        AzureWebJobsStorage = data.azurerm_storage_account.storage.primary_web_endpoint //"DefaultEndpointsProtocol=https;AccountName=${data.azurerm_storage_account.storage.name};AccountKey=${data.azurerm_storage_account.storage.listKeys.keys[0].value};EndpointSuffix=${environment().suffixes.storage}"
        FUNCTIONS_EXTENSION_VERSION = var.extension_version
        FUNCTIONS_WORKER_RUNTIME = var.runtime_name
      },
      var.runtime_name == "python" && var.app_command_line == "" ? { PYTHON_ENABLE_GUNICORN_MULTIWORKERS =  "true"} : {},
      var.application_insights_name != "" ? { APPLICATIONINSIGHTS_CONNECTION_STRING = data.azurerm_application_insights.app_insights.connection_string } : {},
      var.key_vault_name != "" ? { AZURE_KEY_VAULT_ENDPOINT = data.azurerm_key_vault.kv.vault_uri } : {})
  
  identity{ type= length(var.key_vault_name) > 0 ? "SystemAssigned" : "None" }
}
/*
# This is a temporary solution until the azurerm provider supports the basicPublishingCredentialsPolicies resource type
resource "null_resource" "webapp_basic_auth_disable" {
  triggers = {
    account = azurerm_linux_function_app.functions.name
  }

  provisioner "local-exec" {
    command = "az resource update --resource-group ${var.resource_group_name} --name ftp --namespace Microsoft.Web --resource-type basicPublishingCredentialsPolicies --parent sites/${azurerm_linux_function_app.functions.name} --set properties.allow=false && az resource update --resource-group ${var.resource_group_name} --name scm --namespace Microsoft.Web --resource-type basicPublishingCredentialsPolicies --parent sites/${azurerm_linux_function_app.functions.name} --set properties.allow=false"
  }
}
*/
/*
resource "azapi_resource" "webapp_basic_auth_disable_ftp" {
  type = "Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01"
  name = "ftp"
  parent_id = azurerm_linux_function_app.functions.id
  body = jsonencode({
    properties = {
      allow = false
    }
  })
}

resource "azapi_resource" "webapp_basic_auth_disable_scm" {
  type = "Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-09-01"
  name = "scm"
  parent_id = azurerm_linux_function_app.functions.id
  body = jsonencode({
    properties = {
      allow = false
    }
//    kind = "string"
  })
}
*/