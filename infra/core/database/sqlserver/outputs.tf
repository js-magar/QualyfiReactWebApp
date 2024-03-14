output "connection_string_key" {
    value = var.connection_string_key
}
output "databaseName" {
    value = azurerm_sql_database.db.name
}
output "fully_qualified_domain_name" {
    value = azurerm_sql_server.sql_server.fully_qualified_domain_name
}
output "administrator_login" {
    value = azurerm_sql_server.sql_server.administrator_login
}
output "administrator_login_password" {
    value = azurerm_sql_server.sql_server.administrator_login_password
}
