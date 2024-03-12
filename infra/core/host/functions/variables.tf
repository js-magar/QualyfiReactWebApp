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
variable "application_insights_name" {
  type = string
  description = "The name of the app insights"
  default = ""
}

// Reference Properties
variable "app_service_plan_id" {
  type = string
  description = "The app service plan id"
}

variable "key_vault_name" {
  type = string
  description = "The kv name"
  default = ""
}

variable "storage_account_name" {
  type = string
  description = "The storage account name"
  default = ""
}
// Runtime Properties
variable "runtime_name" {
  description = "The runtime name for the function."
  type        = string
  validation {
    condition = can(regex(join("", concat(["^("], [join("|", [ 
            "dotnet", "dotnetcore", "dotnet-isolated", "node", "python", "java", "powershell", "custom"
        ])], [")$"])), var.runtime_name))
    error_message = "Invalid runtime name provided. Allowed values are: dotnet, dotnetcore, dotnet-isolated, node, python, java, powershell, custom."
  }

}

variable "runtime_version" {
  description = "The version of the runtime."
  type        = string
}
// Function Settings
variable "extension_version" {
  description = "The version of the function extension."
  type        = string
  default     = "~4"
 validation {
    condition = can(regex(join("", concat(["^("], [join("|", [ 
            "~4", "~3", "~2", "~1"
        ])], [")$"])), var.extension_version))
    error_message = "Invalid extensionn version provided."
  }
}
// Microsoft.Web/sites Properties

variable "kind" {
  description = "The kind of the function app."
  type        = string
  default     = "functionapp,linux"
}
// Microsoft.Web/sites/config
variable "allowed_origins" {
  description = "Array of allowed origins."
  type        = list(string)
  default     = []
}

variable "always_on" {
  description = "Specifies whether the function app should always be on."
  type        = bool
  default     = true
}

variable "app_command_line" {
  description = "Command line to launch the application."
  type        = string
  default     = ""
}

variable "app_settings" {
  description = "Map of application settings."
  type        = map(string)
  default     = {}
}

variable "client_affinity_enabled" {
  description = "Specifies whether client affinity is enabled."
  type        = bool
  default     = false
}

variable "enable_oryx_build" {
  description = "Specifies whether Oryx build is enabled."
  type        = bool
  default     = true
}

variable "function_app_scale_limit" {
  description = "The maximum number of workers."
  type        = number
  default     = -1
}

variable "minimum_elastic_instance_count" {
  description = "The minimum number of elastic instances."
  type        = number
  default     = -1
}

variable "number_of_workers" {
  description = "The number of workers."
  type        = number
  default     = -1
}

variable "scm_do_build_during_deployment" {
  description = "Specifies whether to build during deployment."
  type        = bool
  default     = true
}

variable "use_32_bit_worker_process" {
  description = "Specifies whether to use a 32-bit worker process."
  type        = bool
  default     = false
}

variable "health_check_path" {
  description = "The health check path."
  type        = string
  default     = ""
}