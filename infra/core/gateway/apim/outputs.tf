
output "apim_service_name" {
    value = "${azurerm_api_management.apim.name}"
}
output "api_management_logger_id" {
  value = "${azurerm_api_management_logger.logger.id}"
}

