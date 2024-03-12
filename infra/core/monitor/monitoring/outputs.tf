
output "application_insights_connection_string" {
    value = "${azurerm_application_insights.app_insights.connection_string}"
}
output "application_insights_instrumentation_key" {
    value = "${azurerm_application_insights.app_insights.instrumentation_key}"
}
output "application_insights_name" {
    value = "${azurerm_application_insights.app_insights.name}"
}
output "log_analytics_workspace_id" {
    value = "${azurerm_log_analytics_workspace.log_analytics.id}"
}
output "log_analytics_workspace_name" {
    value = "${azurerm_log_analytics_workspace.log_analytics.name}"
}
