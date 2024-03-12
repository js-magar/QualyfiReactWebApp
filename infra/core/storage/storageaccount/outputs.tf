
output "name" {
    value = "${azurerm_storage_account.storage.name}"
}
output "primary_endpoints" {
    value = "${azurerm_storage_account.storage.primary_blob_endpoint}"
}