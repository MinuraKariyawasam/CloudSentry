# GLOBAL VARS
variable "resource_group_name" {}
variable "scaleset_scopes" {}
variable "action_group_id" {}


# CPU ALERT VARS
variable "scaleset_cpu_description" {}
variable "cpu_operator" {}
variable "cpu_threshold" {}
variable "cpu_frequency" {}
variable "cpu_severity" {}
variable "cpu_window_size" {}


# MEMORY ALERT VARS
variable "scaleset_memory_description" {}
variable "memory_operator" {}
variable "memory_threshold" {}
variable "memory_frequency" {}
variable "memory_severity" {}
variable "memory_window_size" {}


