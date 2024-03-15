variable "log_analytics_name" {
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

variable "application_insights_name" {
  type = string
  description = "The name of app insights"
  default = ""
}

variable "application_insights_dashboard_name" {
  type = string
  description = "The name of app insights dashboard"
  default = ""
}


variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}