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
variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "publisher_email" {
  type = string
  default = "noreply@microsoft.com"
  description = "The email address of the owner of the service"
  validation {
    condition = length(var.publisher_email) > 0
    error_message = "The length of publisher_email must be at least 1 character."
  }
}

variable "publisher_name" {
  type = string
  default = "n/a"
  description = "The name of the owner of the service"
  validation {
    condition = length(var.publisher_name) > 0
    error_message = "The length of publisher_name must be at least 1 character."
  }
}
variable "sku" {
  type = string
  default = "Consumption"
  description="The pricing tier of this API Management service"
  validation {
    condition = can(regex(join("", concat(["^("], [join("|", [ 
            "Consumption", "Developer", "Standard", "Premium"
        ])], [")$"])), var.sku))
    error_message = "Invalid sku provided."
  }
}
variable "sku_count" {
  type = number
  default = 0
  description="The pricing tier of this API Management service"
  validation {
    condition     = var.sku_count>=0 && var.sku_count<=2
    error_message = "Invalid sku_count provided."
  }
}

variable "application_insights_name" {
  type = string
  description="Azure Application Insights Name"
}