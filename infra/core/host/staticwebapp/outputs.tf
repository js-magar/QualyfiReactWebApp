output "name" {
    value = "${azurerm_static_web_app.static_web_app.name}"
}
output "uri" {
    value = "https://${azurerm_static_web_app.static_web_app.default_host_name}"
}
