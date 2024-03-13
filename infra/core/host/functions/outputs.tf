
output "identityPrincipalId" {
    value = length(var.key_vault_name) > 0 ? azurerm_linux_function_app.functions.identity[0].principal_id : ""
}
output "name" {
    value = "${azurerm_linux_function_app.functions.name}"
}
output "uri" {
    value = "https://${azurerm_linux_function_app.functions.default_hostname}"
}
