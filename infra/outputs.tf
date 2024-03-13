output "app_user_password" {
    value = "${random_password.app_user_password.result}"
}
output "sql_admin_password" {
    value = "${random_password.sql_admin_password.result}"
}