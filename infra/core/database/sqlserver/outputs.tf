output "connection_string_key" {
    value = var.connection_string_key
}
output "databaseName" {
    value = azurerm_sql_database.db.name
}
