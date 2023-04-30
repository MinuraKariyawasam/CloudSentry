# GLOBAL VARS
variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}
variable "location" {
  description = "The location of the Resource Group"
  type        = string
}

variable "scaleset_count" {
  description = "Activate the Module"

}

variable "application_count" {
  description = "Activate the Module"

}

variable "database_count" {
  description = "Activate the Module"

}

variable "vm_host" {
  description = "VM Host"

}

variable "vm_user" {
  description = "VM Username"

}

variable "vm_password" {
  description = "VM Password"

}

variable "bastion_host" {
  description = "Bastion Host"

}

variable "bastion_user" {
  description = "Bastion Username"

}

variable "bastion_password" {
  description = "Bastion Password"
}

# =============================================
#         Application Logs Monitoring
# =============================================

variable "log_forwarder_url" {
  description = "The location of the log file"
  type        = string
}

variable "mongo_db_uri" {
  description = "The location of the log file"
  type        = string
}

# =======================================================
#                    ACTION GROUP
# =======================================================

variable "action_group_name" {
  description = "The name of the Action Group"
  type        = string
}
variable "action_group_short_name" {
  description = "The short name of the Action Group"
  type        = string
}
variable "action_group_receiver_name" {
  description = "The receiver name of the Action Group"
  type        = string
}
variable "action_group_receiver_email" {
  description = "The reveiver email of the Action Group"
  type        = string
}

# =======================================================
#                  LOG ANALYTICS WORKSPACE
# =======================================================

variable "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace"
  type        = string
}
variable "log_analytics_workspace_sku" {
  description = "The sku of the log analytics workspace"
  type        = string
}
variable "retention_in_days" {
  description = "number of retention days"
}

# =======================================================
#                  LOG ANALYTICS SOLUTION
# =======================================================

variable "log_analytics_solution_name" {
  description = "The name of the log analytics solution"
  type        = string
}


# =======================================================
#                  SCALESET MONITORING
# =======================================================

# GLOBAL VARS
variable "scaleset_scopes" {
  description = "The id of the azure scale set"
  type        = string
  default     = ""
}


# CPU ALERT VARS
variable "cpu_operator" {
  description = "The operator of the scale set cpu metric alert"
  type        = string
  default     = "GreaterThan"
}
variable "cpu_threshold" {
  description = "The threshold value of the scale set cpu metric alert"
  default     = 1
}
variable "cpu_frequency" {
  description = "The frequency of the scale set cpu metric alert"
  type        = string
  default     = "PT1M"
}
variable "cpu_severity" {
  description = "The severity of the scale set cpu metric alert"
  default     = 1
}
variable "cpu_window_size" {
  description = "The cpu window size of the scale set cpu metric alert"
  type        = string
  default     = "PT15M"
}


# MEMORY ALERT VARS
variable "memory_operator" {
  description = "The operator of the scale set memory metric alert"
  type        = string
  default     = "GreaterThan"
}
variable "memory_threshold" {
  description = "The threshold value of the scale set memory metric alert"
  default     = 1
}
variable "memory_frequency" {
  description = "The frequency of the scale set cpu metric alert"
  type        = string
  default     = "PT1M"
}
variable "memory_severity" {
  description = "The severity of the scale set cpu metric alert"
  default     = 1
}
variable "memory_window_size" {
  description = "The cpu window size of the scale set cpu metric alert"
  type        = string
  default     = "PT15M"
}

# =======================================================
#            APPLICATION GATEWAY MONITORING
# =======================================================


# GLOBAL VARS
variable "appgateway_scopes" {
  description = "The id of the azure application gateway"
  type        = list(string)
  default     = []
}


# APP GATEWAY RESPONSE STATUS

variable "response_status_operator" {
  description = "The operator of application gateway response status metric alert"
  type        = string
  default     = "GreaterThan"
}
variable "response_status_threshold" {
  description = "The threshold of application gateway response status metric alert"
  default     = 1
}
variable "response_status_frequency" {
  description = "The frequency of application gateway response status metric alert"
  type        = string
  default     = "PT1M"
}
variable "response_status_severity" {
  description = "The severrity of application gateway response status metric alert"
  default     = 1
}
variable "response_status_window_size" {
  description = "The window size of application gateway response status metric alert"
  type        = string
  default     = "PT15M"
}


# APP GATEWAY UNHEALTHY HOST COUNT

variable "unhealthy_host_count_operator" {
  description = "The operator of application gateway unhealthy host count metric alert"
  type        = string
  default     = "GreaterThan"
}
variable "unhealthy_host_count_threshold" {
  description = "The threshold of application gateway unhealthy host count metric alert"
  default     = 1
}
variable "unhealthy_host_count_frequency" {
  description = "The frequency of application gateway unhealthy host count metric alert"
  type        = string
  default     = "PT1M"
}
variable "unhealthy_host_count_severity" {
  description = "The severrity of application gateway unhealthy host count metric alert"
  default     = 1
}
variable "unhealthy_host_count_window_size" {
  description = "The window size of application gateway unhealthy host count metric alert"
  type        = string
  default     = "PT15M"
}



# =======================================================
#            MYSQL DATABASE MONITORING
# =======================================================

# GLOBAL VARS
variable "database_scopes" {
  description = "The id of the azure MySQL Server."
  type        = list(string)
  default     = []
}


# MYSQL DATABASE CPU ALERT

variable "database_cpu_operator" {
  description = "The operator of mysql server cpu metric alert"
  type        = string
  default     = "GreaterThan"
}
variable "database_cpu_threshold" {
  description = "The threshold of mysql server cpu metric alert"
  default     = 1
}
variable "database_cpu_frequency" {
  description = "The frequency of mysql server cpu metric alert"
  type        = string
  default     = "PT1M"
}
variable "database_cpu_severity" {
  description = "The severity of mysql server cpu metric alert"
  default     = 1
}
variable "database_cpu_window_size" {
  description = "The window size of mysql server cpu metric alert"
  type        = string
  default     = "PT15M"
}


# MYSQL DATABASE STORAGE ALERT

variable "database_storage_operator" {
  description = "The operator of mysql server storage metric alert"
  type        = string
  default     = "GreaterThan"
}
variable "database_storage_threshold" {
  description = "The threshold of mysql server storage metric alert"
  default     = 1
}
variable "database_storage_frequency" {
  description = "The frequency of mysql server storage metric alert"
  type        = string
  default     = "PT1M"
}
variable "database_storage_severity" {
  description = "The severity of mysql server storage metric alert"
  default     = 1
}
variable "database_storage_window_size" {
  description = "The window size of mysql server storage metric alert"
  type        = string
  default     = "PT15M"
}