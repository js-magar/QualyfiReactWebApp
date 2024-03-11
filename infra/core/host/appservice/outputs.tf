
output "identityPrincipalId" {
    value = managedIdentity ? appService.identity.principalId : ""
}
output "name" {
    value = "${azurerm_app_service.app_service.name}"
}
output "uri" {
    value = "https://${azurerm_app_service.app_service.defaultHostname}"
}
