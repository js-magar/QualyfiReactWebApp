variable "name" {
  type = string
  description = "The name of the account"
}

variable "location" {
  type = string
  description = "The location of the account"
}

variable "resource_group_name" {
  type = string
  description = "The rg name"
}
/*
variable "tags" {
  type = object
  description = "The location of the account"
}
*/

variable "customSubDomainName" {
  type = string
  description = "The custom subdomain name used to access the API. Defaults to the value of the name parameter."
}

variable "deployments" {
  description = "The array of the deployments"
  default = []
}

variable "kind" {
  type = string
  description = "The kind of the account"
  default = "OpenAI"
}

variable "publicNetworkAccess" {
  type = string
  description = "publicNetworkAccess"
  default = "Enabled"
}

variable "sku_name" {
  type = string
  description = "SKU"
  default =  "S0"
}

variable "allowedIpRules" {
  type = list(string)
  description = "allowedIpRules"
  default = []
}

variable "networkAcls" {
  type = object({
    ipRules = string
    defaultAction = string
  })
  description = "The kind of the account"
  default = {defaultAction = "Allow"}
}