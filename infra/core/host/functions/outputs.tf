
output "identityPrincipalId" {
    value = managedIdentity ? functions.identity.principalId : ""
}
output "name" {
    value = "${azurerm_app_service.functions.name}"
}
output "uri" {
    value = "https://${azurerm_app_service.functions.defaultHostname}"
}
