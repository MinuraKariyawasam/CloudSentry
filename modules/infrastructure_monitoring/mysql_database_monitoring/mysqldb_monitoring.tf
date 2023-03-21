# -----------------------------------------------------------
#           AZURE MYSQL SERVER - MONITORING
# -----------------------------------------------------------

# MYSQL DATABASE CPU ALERT
resource "azurerm_monitor_metric_alert" "sentry-mysql-db-cpu" {
  name                = "sentry MYSQL DATABASE - CPU METRIC ALERT"
  resource_group_name = var.resource_group_name
  scopes              = var.database_scopes
  description         = var.database_cpu_description

  criteria {
    metric_namespace = "Microsoft.DBforMySQL/servers"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = var.database_cpu_operator
    threshold        = var.database_cpu_threshold
  }

  action {
    action_group_id = var.action_group_id
  }

  frequency   = var.database_cpu_frequency
  severity    = var.database_cpu_severity
  window_size = var.database_cpu_window_size

}

# MYSQL DATABASE STORAGE ALERT
resource "azurerm_monitor_metric_alert" "sentry-mysql-db-storage" {
  name                = "sentry MYSQL DATABASE - STORAGE METRIC ALERT"
  resource_group_name = var.resource_group_name
  scopes              = var.database_scopes
  description         = var.database_storage_description

  criteria {
    metric_namespace = "Microsoft.DBforMySQL/servers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = var.database_storage_operator
    threshold        = var.database_storage_threshold
  }

  action {
    action_group_id = var.action_group_id
  }

  frequency   = var.database_storage_frequency
  severity    = var.database_storage_severity
  window_size = var.database_storage_window_size

}

# MYSQL DATABASE MEMORY ALERT
# resource "azurerm_monitor_metric_alert" "sentry-mysql-db-memory" {
#   name                = "sentry MYSQL DATABASE - MEMORY METRIC ALERT"
#   resource_group_name = var.resource_group_name
#   scopes              = var.database_scopes
#   description         = var.database_memory_description

#   criteria {
#     metric_namespace = "Microsoft.DBforMySQL/servers"
#     metric_name      = "memory_percent"
#     aggregation      = "Average"
#     operator         = var.database_memory_operator
#     threshold        = var.database_memory_threshold
#   }

#   action {
#     action_group_id = var.action_group_id
#   }

#   frequency   = var.database_memory_frequency
#   severity    = var.database_memory_severity
#   window_size = var.database_memory_window_size
# }

# # MYSQL DATABASE CONNECTION FAILD ALERT
# resource "azurerm_monitor_metric_alert" "sentry-mysql-db-connection-faild" {
#   name                = "sentry MYSQL DATABASE - CONNECTION FAILD ALERT"
#   resource_group_name = var.resource_group_name
#   scopes              = var.database_scopes
#   description         = var.database_connection_faild_description

#   criteria {
#     metric_namespace = "Microsoft.DBforMySQL/servers"
#     metric_name      = "connections_failed"
#     aggregation      = "Total"
#     operator         = var.database_connection_faild_operator
#     threshold        = var.database_connection_faild_threshold
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.vmss.id
#   }

#   frequency   = var.database_connection_faild_frequency
#   severity    = var.database_connection_faild_severity
#   window_size = var.database_connection_faild_window_size
# }
