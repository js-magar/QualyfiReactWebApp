
output "identityPrincipalId" {
    value = managedIdentity ? azurerm_app_service.app_service.identity.principal_id : ""
}
output "name" {
    value = "${azurerm_app_service.app_service.name}"
}
output "uri" {
    value = "https://${azurerm_app_service.app_service.default_host_name}"
}
