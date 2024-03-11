
output "identityPrincipalId" {
    value = managedIdentity ? azurerm_app_service.functions.identity.principal_id : ""
}
output "name" {
    value = "${azurerm_app_service.functions.name}"
}
output "uri" {
    value = "https://${azurerm_app_service.functions.default_host_name}"
}
