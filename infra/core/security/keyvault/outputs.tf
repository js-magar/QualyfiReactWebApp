
output "endpoint" {
    value = "${azurerm_key_vault.key_vault.vault_uri}"
}
output "name" {
    value = "${azurerm_key_vault.key_vault.name}"
}
