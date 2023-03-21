# GLOBAL VARS
variable "resource_group_name" {}
variable "database_scopes" {}
variable "action_group_id" {}


# MYSQL DATABASE CPU ALERT
variable "database_cpu_description" {}
variable "database_cpu_operator" {}
variable "database_cpu_threshold" {}
variable "database_cpu_frequency" {}
variable "database_cpu_severity" {}
variable "database_cpu_window_size" {}


# MYSQL DATABASE STORAGE ALERT
variable "database_storage_description" {}
variable "database_storage_operator" {}
variable "database_storage_threshold" {}
variable "database_storage_frequency" {}
variable "database_storage_severity" {}
variable "database_storage_window_size" {}


# MYSQL DATABASE MEMORY ALERT
# variable "database_memory_description" {}
# variable "database_memory_operator" {}
# variable "database_memory_threshold" {}
# variable "database_memory_frequency" {}
# variable "database_memory_severity" {}
# variable "database_memory_window_size" {}


# # MYSQL DATABASE CONNECTION FAILD ALERT
# variable "database_connection_faild_description" {}
# variable "database_connection_faild_operator" {}
# variable "database_connection_faild_threshold" {}
# variable "database_connection_faild_frequency" {}
# variable "database_connection_faild_severity" {}
# variable "database_connection_faild_window_size" {}