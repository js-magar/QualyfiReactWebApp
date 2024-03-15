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
variable "kind" {
  type = string
  description = "The kind of app service"
}
variable "sku" {
  type = object({
    tier = string
    size = string
  })
  description = "The sku fro apps ervice"
}
variable "reserved" {
  type = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}