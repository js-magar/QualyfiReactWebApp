variable "name" {
  type = string
  description = "The name of the web app"
}

variable "location" {
  type = string
  description = "The location of the web app"
}

variable "resource_group_name" {
  type = string
  description = "The rg name"
}

variable "sku" {
  type = string
  description = "The sku of the web app"
  default = "Free"
}
