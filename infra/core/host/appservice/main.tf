//Creates an Azure Function in an existing Azure App Service plan.

data "azurerm_application_insights" "app_insights" {
  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
locals {
  linux_fx_version = "${var.runtime_name}|${var.runtime_version}"
  managed_identity = length(var.key_vault_name) > 0
}

resource "azurerm_app_service" "app_service" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id     = var.app_service_plan_id

  site_config {
      always_on = var.always_on
      app_command_line = var.app_command_line 
      cors {
        allowed_origins= union([ "https://portal.azure.com", "https://ms.portal.azure.com" ], allowedOrigins)
      }
      ftps_state = "FtpsOnly"
      health_check_path = var.health_check_path
      linux_fx_version = local.linux_fx_version //To set this property the App Service Plan to which the App belongs must be configured with kind = "Linux", and reserved = true or the API will reject any value supplied.
      min_tls_version =  "1.2"
      number_of_workers = var.number_of_workers != -1 ? var.number_of_workers : null
      use_32_bit_worker_process =  var.use_32_bit_worker_process
    }
  client_affinity_enabled = var.client_affinity_enabled
  https_only=true
  identity{ type= local.managed_identity ? "SystemAssigned" : "None" }
  app_settings = union(var.app_settings,
      {
        SCM_DO_BUILD_DURING_DEPLOYMENT = string(var.scm_do_build_during_deployment)
        ENABLE_ORYX_BUILD = string(var.enable_oryx_build)
      },
      var.runtimeName == "python" && var.app_command_line == "" ? { PYTHON_ENABLE_GUNICORN_MULTIWORKERS =  "true"} : {},
      !empty(var.application_insights_name) ? { APPLICATIONINSIGHTS_CONNECTION_STRING = data.azurerm_application_insights.app_insights.ConnectionString } : {},
      !empty(var.key_vault_name) ? { AZURE_KEY_VAULT_ENDPOINT = data.azurerm_key_vault.kv.vaultUri } : {})
  logs{
    detailed_error_messages_enabled = true
    failed_request_tracing_enabled = true
    application_logs {
      file_system_level = "Verbose"
    }
    http_logs {
      file_system {
        retention_in_days = 1
        retention_in_mb = 35
      }
    }
  }
}
