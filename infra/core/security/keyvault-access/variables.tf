variable "name" {
  type = string
  description = "The name of the app service plan"
  default = "add"
}

variable "resource_group_name" {
  type = string
  description = "The rg name"
}
variable "principal_id" {
  type = string
  description = "The kind of app service"
  default = ""
}

variable "permissions" {
  type = object({
    secrets = list(string)
  })
  description = "The permissions given"
  default = {
    secrets = [ "Get", "List" ]
  }
}

variable "key_vault_name" {
  type = string
  description = "The name of the kv"
}