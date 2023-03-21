# ------------------------------------------------------------------
#                APPLICATION GATEWAY MONITORING 
# ------------------------------------------------------------------

# APP GATEWAY RESPONSE STATUS
resource "azurerm_monitor_metric_alert" "sentry-application-gateway-response-status" {
  name                = "sentry APPLICATION GATEWAY - RESPONSE STATUS"
  resource_group_name = var.resource_group_name
  scopes              = var.appgateway_scopes
  description         = var.response_status_description

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "ResponseStatus"
    aggregation      = "Total"
    operator         = var.response_status_operator
    threshold        = var.response_status_threshold

    dimension {
      name     = "HttpStatusGroup"
      operator = "Include"
      values   = ["404", "503"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  frequency   = var.response_status_frequency
  severity    = var.response_status_severity
  window_size = var.response_status_window_size
}

# APP GATEWAY THROUGHPUT
# resource "azurerm_monitor_metric_alert" "sentry-application-gateway-throughput" {
#   name                = "sentry APPLICATION GATEWAY - THROUGHPUT"
#   resource_group_name = var.resource_group_name
#   scopes              = var.appgateway_scopes
#   description         = var.throughput_description

#   criteria {
#     metric_namespace = "Microsoft.Network/applicationGateways"
#     metric_name      = "Throughput"
#     aggregation      = "Average"
#     operator         = var.throughput_operator
#     threshold        = var.throughput_threshold

#   }

#   action {
#     action_group_id = var.action_group_id
#   }

#   frequency   = var.throughput_frequency
#   severity    = var.throughput_severity
#   window_size = var.throughput_window_size
# }

# APP GATEWAY UNHEALTHY HOST COUNT
resource "azurerm_monitor_metric_alert" "sentry-application-gateway-unhealthy-host-count" {
  name                = "sentry APPLICATION GATEWAY - Unhealthy Host Count"
  resource_group_name = var.resource_group_name
  scopes              = var.appgateway_scopes
  description         = var.unhealthy_host_count_description

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "UnhealthyHostCount"
    aggregation      = "Average"
    operator         = var.unhealthy_host_count_operator
    threshold        = var.unhealthy_host_count_threshold

    dimension {
      name     = "BackendSettingsPool"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  frequency   = var.unhealthy_host_count_frequency
  severity    = var.unhealthy_host_count_severity
  window_size = var.unhealthy_host_count_window_size
}

# APP GATEWAY REQUEST COUNT PER HEALTHY HOST
# resource "azurerm_monitor_metric_alert" "sentry-application-gateway-Avg-request-count-per-healthy-host" {
#   name                = "sentry APPLICATION GATEWAY - Avg Request Count Per Healthy Host"
#   resource_group_name = var.resource_group_name
#   scopes              = var.appgateway_scopes
#   description         = var.request_count_description

#   criteria {
#     metric_namespace = "Microsoft.Network/applicationGateways"
#     metric_name      = "AvgRequestCountPerHealthyHost"
#     aggregation      = "Average"
#     operator         = var.request_count_operator
#     threshold        = var.request_count_threshold

#     dimension {
#       name     = "BackendSettingsPool"
#       operator = "Include"
#       values   = ["*"]
#     }
#   }

#   action {
#   action_group_id = var.action_group_id
#   }

#   frequency   = var.request_count_frequency
#   severity    = var.request_count_severity
#   window_size = var.request_count_window_size
# }