# GLOBAL VARS
variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}
variable "location" {
  description = "The location of the Resource Group"
  type        = string
}

# =============================================
#           JVM Application Insight
# =============================================

# variable "application_insight_name" {
#   description = "The name of the Application Insight"
#   type        = string
# }

# =============================================
#         Application Logs Monitoring
# =============================================

variable "log_forwarder_url" {
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
}


# CPU ALERT VARS
variable "scaleset_cpu_description" {
  description = "The description of scale set cpu metric alert"
  type        = string
}
variable "cpu_operator" {
  description = "The operator of the scale set cpu metric alert"
  type        = string
}
variable "cpu_threshold" {
  description = "The threshold value of the scale set cpu metric alert"
}
variable "cpu_frequency" {
  description = "The frequency of the scale set cpu metric alert"
  type        = string
}
variable "cpu_severity" {
  description = "The severity of the scale set cpu metric alert"
}
variable "cpu_window_size" {
  description = "The cpu window size of the scale set cpu metric alert"
  type        = string
}


# MEMORY ALERT VARS
variable "scaleset_memory_description" {
  description = "The description of scale set memory metric alert"
  type        = string
}
variable "memory_operator" {
  description = "The operator of the scale set memory metric alert"
  type        = string
}
variable "memory_threshold" {
  description = "The threshold value of the scale set memory metric alert"
}
variable "memory_frequency" {
  description = "The frequency of the scale set cpu metric alert"
  type        = string
}
variable "memory_severity" {
  description = "The severity of the scale set cpu metric alert"
}
variable "memory_window_size" {
  description = "The cpu window size of the scale set cpu metric alert"
  type        = string
}

# =======================================================
#            APPLICATION GATEWAY MONITORING
# =======================================================


# # GLOBAL VARS
# variable "appgateway_scopes" {
#   description = "The id of the azure application gateway"
#   type        = list(string)
#   default     = []
# }


# # APP GATEWAY RESPONSE STATUS
# variable "response_status_description" {
#   description = "The description of application gateway response status metric alert"
#   type        = string
# }
# variable "response_status_operator" {
#   description = "The operator of application gateway response status metric alert"
#   type        = string
# }
# variable "response_status_threshold" {
#   description = "The threshold of application gateway response status metric alert"
# }
# variable "response_status_frequency" {
#   description = "The frequency of application gateway response status metric alert"
#   type        = string
# }
# variable "response_status_severity" {
#   description = "The severrity of application gateway response status metric alert"
# }
# variable "response_status_window_size" {
#   description = "The window size of application gateway response status metric alert"
#   type        = string
# }


# # APP GATEWAY UNHEALTHY HOST COUNT
# variable "unhealthy_host_count_description" {
#   description = "The description of application gateway unhealthy host count metric alert"
#   type        = string
# }
# variable "unhealthy_host_count_operator" {
#   description = "The operator of application gateway unhealthy host count metric alert"
#   type        = string
# }
# variable "unhealthy_host_count_threshold" {
#   description = "The threshold of application gateway unhealthy host count metric alert"
# }
# variable "unhealthy_host_count_frequency" {
#   description = "The frequency of application gateway unhealthy host count metric alert"
#   type        = string
# }
# variable "unhealthy_host_count_severity" {
#   description = "The severrity of application gateway unhealthy host count metric alert"
# }
# variable "unhealthy_host_count_window_size" {
#   description = "The window size of application gateway unhealthy host count metric alert"
#   type        = string
# }



# # =======================================================
# #            MYSQL DATABASE MONITORING
# # =======================================================

# # GLOBAL VARS
# variable "database_scopes" {
#   description = "The id of the azure MySQL Server."
#   type        = list(string)
#   default     = []
# }


# # MYSQL DATABASE CPU ALERT
# variable "database_cpu_description" {
#   description = "The description of mysql server cpu metric alert"
#   type        = string
# }
# variable "database_cpu_operator" {
#   description = "The operator of mysql server cpu metric alert"
#   type        = string
# }
# variable "database_cpu_threshold" {
#   description = "The threshold of mysql server cpu metric alert"
# }
# variable "database_cpu_frequency" {
#   description = "The frequency of mysql server cpu metric alert"
#   type        = string
# }
# variable "database_cpu_severity" {
#   description = "The severity of mysql server cpu metric alert"
# }
# variable "database_cpu_window_size" {
#   description = "The window size of mysql server cpu metric alert"
#   type        = string
# }


# # MYSQL DATABASE STORAGE ALERT
# variable "database_storage_description" {
#   description = "The description of mysql server storage metric alert"
#   type        = string
# }
# variable "database_storage_operator" {
#   description = "The operator of mysql server storage metric alert"
#   type        = string
# }
# variable "database_storage_threshold" {
#   description = "The threshold of mysql server storage metric alert"
# }
# variable "database_storage_frequency" {
#   description = "The frequency of mysql server storage metric alert"
#   type        = string
# }
# variable "database_storage_severity" {
#   description = "The severity of mysql server storage metric alert"
# }
# variable "database_storage_window_size" {
#   description = "The window size of mysql server storage metric alert"
#   type        = string
# }