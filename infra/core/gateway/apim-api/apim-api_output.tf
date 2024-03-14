output "service_api_url" {
  value = "${data.azurerm_api_management.apim.gateway_url}/${var.api_path}"
}
