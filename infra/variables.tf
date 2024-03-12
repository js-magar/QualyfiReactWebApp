variable "resource_group_name" {
  type        = string
  description = "The rg name"
  default     = ""
}
variable "location" {
  type        = string
  description = "The location of the rg"
  default     = "East US 2"
}
variable "environment_name" {
  description = "Name of the environment which is used to generate a short unique hash used in all resources."
  type        = string
  default     = "default_environment" // You can provide a default value if needed

  validation {
    condition     = length(var.environment_name) > 0 && length(var.environment_name) <= 64
    error_message = "environment_name must be between 1 and 64 characters long"
  }
}
variable "api_service_name" {
  description = "Name of the API service"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "application_insights_dashboard_name" {
  description = "Name of the Application Insights dashboard"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "application_insights_name" {
  description = "Name of the Application Insights resource"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "log_analytics_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
  type        = string
  default     = "ToDo" // Provide a default value if needed
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "web_service_name" {
  description = "Name of the Web Service"
  type        = string
  default     = "" // Provide a default value if needed
}

variable "apim_service_name" {
  description = "Name of the API Management Service"
  type        = string
  default     = "" // Provide a default value if needed
}
variable "use_apim" {
  type        = bool
  default     = false
  description = "Flag to use Azure API Management to mediate the calls between the Web frontend and the backend API"
}

variable "principal_id" {
  type        = string
  default     = ""
  description = "Id of the user or app to assign application roles"
}

variable "sql_admin_password" {
  type        = string
  description = "SQL Server administrator password"
  sensitive   = true
}

variable "app_user_password" {
  type        = string
  description = "Application user password"
  sensitive   = true
}