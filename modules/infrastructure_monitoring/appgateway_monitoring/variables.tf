# GLOBAL VARS
variable "resource_group_name" {}
variable "appgateway_scopes" {}
variable "action_group_id" {}


# APP GATEWAY RESPONSE STATUS
variable "response_status_description" {}
variable "response_status_operator" {}
variable "response_status_threshold" {}
variable "response_status_frequency" {}
variable "response_status_severity" {}
variable "response_status_window_size" {}


# # APP GATEWAY THROUGHPUT
# variable "throughput_description" {}
# variable "throughput_operator" {}
# variable "throughput_threshold" {}
# variable "throughput_frequency" {}
# variable "throughput_severity" {}
# variable "throughput_window_size" {}


# APP GATEWAY UNHEALTHY HOST COUNT
variable "unhealthy_host_count_description" {}
variable "unhealthy_host_count_operator" {}
variable "unhealthy_host_count_threshold" {}
variable "unhealthy_host_count_frequency" {}
variable "unhealthy_host_count_severity" {}
variable "unhealthy_host_count_window_size" {}


# # APP GATEWAY REQUEST COUNT PER HEALTHY HOST
# variable "request_count_description" {}
# variable "request_count_operator" {}
# variable "request_count_threshold" {}
# variable "request_count_frequency" {}
# variable "request_count_severity" {}
# variable "request_count_window_size" {}