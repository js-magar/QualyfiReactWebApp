#Creates an Azure API Management instance.
resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_email     = var.publisher_email
  publisher_name      = var.publisher_name
  tags                = var.tags

  sku_name = "${var.sku}_${var.sku == "Consumption" ? 0 : (var.sku == "Developer" ? 1 : var.sku_count)}"
  security {
    enable_backend_ssl30 = false
    enable_backend_tls10 = false
    enable_backend_tls11 = false
    enable_frontend_ssl30 = false
    enable_frontend_tls10 = false
    enable_frontend_tls11 = false
    tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = false
    tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = false
    tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled = false
    tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled = false
    tls_rsa_with_aes128_cbc_sha256_ciphers_enabled = false
    tls_rsa_with_aes128_cbc_sha_ciphers_enabled = false
    tls_rsa_with_aes128_gcm_sha256_ciphers_enabled = false
    tls_rsa_with_aes256_cbc_sha256_ciphers_enabled = false
    tls_rsa_with_aes256_cbc_sha_ciphers_enabled = false
    tls_rsa_with_aes256_gcm_sha384_ciphers_enabled = false
    triple_des_ciphers_enabled = false
  }
}

resource "azurerm_api_management_logger" "apim_logger" {
  name        = "app-insights-logger"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  description = "Logger to Azure Application Insights"
  buffered = false
  application_insights {
    instrumentation_key = data.azurerm_application_insights.app_insights.instrumentation_key
  }
}

data "azurerm_application_insights" "app_insights" {
  name  = var.application_insights_name
  resource_group_name = var.resource_group_name
}
