# ------------------------------------------------------------------
#                     SCALE SET MONITORING
# ------------------------------------------------------------------

# CPU MONITORING
resource "azurerm_monitor_metric_alert" "scaleset-cpu" {
  name                = "SCALE SET - HIGH CPU PRECENETAGE"
  resource_group_name = var.resource_group_name
  scopes              = [var.scaleset_scopes]
  description         = var.scaleset_cpu_description
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = var.cpu_operator
    threshold        = var.cpu_threshold

    dimension {
      name     = "VMName"
      operator = "Include"
      values   = ["*"]
    }

  }

  # action {
  #   action_group_id = var.action_group_id
  # }
   frequency   = var.cpu_frequency
   severity    = var.cpu_severity
   window_size = var.cpu_window_size
}


# MEMORY MONITORING
resource "azurerm_monitor_metric_alert" "sentry-scaleset-memory" {
  name                = "SCALE SET - HIGH MEMORY USAGE"
  resource_group_name = var.resource_group_name
  scopes              = [var.scaleset_scopes]
  description         = var.scaleset_memory_description

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = var.memory_operator
    threshold        = var.memory_threshold

    dimension {
      name     = "VMName"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }
   frequency   = var.memory_frequency
   severity    = var.memory_severity
   window_size = var.memory_window_size
}