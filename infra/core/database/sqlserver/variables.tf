variable "name" {
  type = string
  description = "The name of the sql server"
}

variable "location" {
  type = string
  description = "The location of the sqls erver"
}

variable "resource_group_name" {
  type = string
  description = "The rg name"
}
variable "app_user" {
  type = string
  description = "The user's username"
  default = "appUser"
}
variable "database_name" {
  type = string
  description = "The db name"
}
variable "key_vault_name" {
  type = string
  description = "The kv name"
}
variable "sql_admin" {
  type = string
  description = "The admin's username"
  default = "sqlAdmin"
}
variable "connection_string_key" {
  type = string
  description = "The rg name"
  default = "AZURE-SQL-CONNECTION-STRING"
}
variable "sql_admin_password" {
    type = string
}
variable "sql_user_password" {
  type = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}