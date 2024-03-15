variable "name" {
  type = string
  description = "The name of the app service plan"
}

variable "location" {
  type = string
  description = "The location of the app service plan"
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
variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}
