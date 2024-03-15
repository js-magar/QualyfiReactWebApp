variable "name" {
  type = string
  description = "The name of the log analytics"
}

variable "location" {
  type = string
  description = "The location of the rg"
}

variable "resource_group_name" {
  type = string
  description = "The rg name"
}

variable "access_tier" {
  type = string
  default = "Hot"
  validation {
    condition = can(regex(join("", concat(["^("], [join("|", [ 
            "Cool", "Hot", "Premium"
        ])], [")$"])), var.access_tier))
    error_message = "Invalid access_tier provided."
  }
}

variable "allow_blob_public_access" {
  type = bool
  default = true
}
variable "allow_cross_tenant_replication" {
  type = bool
  default = true
}
variable "allow_shared_key_access" {
  type = bool
  default = true
}
variable "containers" { //{name,public access}
  type = list
  default = []
}
variable "default_to_oauth_authentication" {
  type = bool
  default = false
}
variable "delete_retention_policy" {
  type=object({})
  /*
  type=object({
    enable = bool
    days = string 
  })
  */
  default = {}
}
variable "dns_endpoint_type" {
  type = string
  default = "Standard"
  validation {
    condition = can(regex(join("", concat(["^("], [join("|", [ 
            "AzureDnsZone", "Standard"
        ])], [")$"])), var.dns_endpoint_type))
    error_message = "Invalid dns_endpoint_type provided."
  }
}
variable "kind" {
  type = string
  default = "StorageV2"
}

variable "minimum_tls_version" {
  type = string
  default = "TLS1_2"
}

variable "supports_https_traffic_only" {
  type = bool
  default = true
}

variable "network_acls" {
  type = object({
    bypass = list(string)
    default_action = string
  })
  default = {
    bypass = ["AzureServices"]
    default_action = "Allow"
  }
}
variable "public_network_access" {
  type = bool
  default = true
}
variable "sku" {
  type = object({
    name = string
    account_replication_type = string
    account_tier=string
  })
  default = { 
    name = "Standard_LRS"
    account_replication_type = "LRS"
    account_tier = "Standard"
  }
}
variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}