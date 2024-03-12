
output "identityPrincipalId" {
    value = local.managed_identity ? azurerm_app_service.functions.identity[0].principal_id : ""
}
output "name" {
    value = "${azurerm_app_service.functions.name}"
}
output "uri" {
    value = "https://${azurerm_app_service.functions.default_site_hostname}"
}
