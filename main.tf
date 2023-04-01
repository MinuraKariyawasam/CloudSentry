# =============================================
#           CLOUDSENTRY Monitoring Solution
# =============================================

# =============================================
#           JVM Application Insight
# =============================================

# resource "azurerm_application_insights" "jvm" {
#   name                = var.application_insight_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   application_type    = "java"
# }

# =============================================
#         Application Logs Monitoring
# =============================================

# Create a virtual machine scale set extension
# resource "azurerm_virtual_machine_scale_set_extension" "log_forwarder" {

#   name                         = "log-forwarder"
#   virtual_machine_scale_set_id = var.scaleset_scopes
#   publisher                    = "Microsoft.Azure.Extensions"
#   type                         = "CustomScript"
#   type_handler_version         = "2.1"


#   # Define the settings object for the extension
#   settings = jsonencode({
#     fileUris          = ["/opt/log-forwarder/log-forwarder.sh"],
#     commandToExecute  = "/bin/bash /opt/log-forwarder/log-forwarder.sh",
#     mongo_connection  = "mongodb+srv://minurakariyawasaminfo:RyQ3jWW2ZbttOFYD@cluster0.nfyfngf.mongodb.net/?retryWrites=true&w=majority",
#     database_name     = "mydb",
#     collection_name   = "applicationLogs",
#     log_forwarder_url = var.log_forwarder_url
#   })

#   # Define the provisioner block for remote execution
#   provisioner "remote-exec" {

#     connection {
#       type         = "ssh"
#       host         = "10.0.2.7"
#       user         = "azureuser"
#       password     = "kN@ldoWds0o1"
#       agent        = false
#       timeout      = "5m"
#       bastion_host = "fkybdk-ssh.eastus2.cloudapp.azure.com"
#     }
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install -y mongodb-clients",
#       "sudo mkdir -p /opt/log-forwarder",
#       "sudo chown -R $USER:$USER /opt/log-forwarder",
#       "echo '#!/bin/bash' > /opt/log-forwarder/log-forwarder.sh",
#       "echo \"uri='${jsondecode(azurerm_virtual_machine_scale_set_extension.log_forwarder[count.index].settings).mongo_connection}'\" >> /opt/log-forwarder/log-forwarder.sh",
#       "echo \"database='${jsondecode(azurerm_virtual_machine_scale_set_extension.log_forwarder[count.index].settings).database_name}'\" >> /opt/log-forwarder/log-forwarder.sh",
#       "echo \"collection='${jsondecode(azurerm_virtual_machine_scale_set_extension.log_forwarder[count.index].settings).collection_name}'\" >> /opt/log-forwarder/log-forwarder.sh",
#       "echo \"log_file='${jsondecode(azurerm_virtual_machine_scale_set_extension.log_forwarder[count.index].settings).log_forwarder_url}'\" >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '# Start tailing the log file and sending new data to MongoDB' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo 'tail -F $log_file | while read line' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo 'do' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  # Extract the relevant data from the log line' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  date=$(echo $line | awk \"{print \\$1}\")' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  time=$(echo $line | awk \"{print \\$2}\")' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  level=$(echo $line | awk \"{print \\$3}\")' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  message=$(echo $line | awk \"{\\$1=\\$2=\\$3=\\\"\\\"; print \\$0}\")' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  # Build the JSON object to send to MongoDB' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  json=\"{\\\"date\\\":\\\"$date\\\",\\\"time\\\":\\\"$time\\\",\\\"level\\\":\\\"$level\\\",\\\"message\\\":\\\"$message\\\"}\"' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  # Send the JSON object to MongoDB using the `mongoimport` command' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo '  echo $json | mongoimport --uri=$uri --collection=$collection --db=$database --quiet' >> /opt/log-forwarder/log-forwarder.sh",
#       "echo 'done' >> /opt/log-forwarder/log-forwarder.sh",
#       "chmod +x /opt/log-forwarder/log-forwarder.sh"
#     ]
#   }
# }




resource "azurerm_virtual_machine_scale_set_extension" "log_forwarder" {
  name                         = "log-forwarder"
  virtual_machine_scale_set_id = var.scaleset_scopes
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.1"
  settings                     = <<SETTINGS
    {
      "fileUris": ["/opt/log-forwarder/log-forwarder.sh"],
      "commandToExecute": "/bin/bash /opt/log-forwarder/log-forwarder.sh"
    }
SETTINGS

  provisioner "remote-exec" {
    connection {
      type         = "ssh"
      host         = "10.0.2.5"
      user         = "azureuser"
      password     = "kN@ldoWds0o1"
      agent        = false
      timeout      = "5m"
      bastion_host = "20.12.70.135"

    }
    inline = [
      "sudo apt-get update",
      "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org-shell=3.6.22 mongodb-org-tools=3.6.22",
      "sudo mkdir -p /opt/log-forwarder",
      "sudo chown -R $USER:$USER /opt/log-forwarder",
      "echo '#!/bin/bash' > /opt/log-forwarder/log-forwarder.sh",
      "echo '# Set the MongoDB connection URI' >> /opt/log-forwarder/log-forwarder.sh",
      "echo \"uri='mongodb+srv://minurakariyawasaminfo:RyQ3jWW2ZbttOFYD@cluster0.nfyfngf.mongodb.net/centry_logs?retryWrites=true&w=majority'\" >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '# Set the name of the database and collection to store logs' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'database=\"centry_logs\"' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'collection=\"app_logs\"' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '# Set the path to the log file to monitor' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'log_file=\"${var.log_forwarder_url}\"' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '# Start tailing the log file and sending new data to MongoDB' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'tail -F $log_file | while read line' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'do' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  # Extract the relevant data from the log line' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  date=$(echo $line | awk \"{print \\$1}\")' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  time=$(echo $line | awk \"{print \\$2}\")' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  level=$(echo $line | awk \"{print \\$3}\")' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  message=$(echo $line | awk \"{\\$1=\\$2=\\$3=\\\"\\\"; print \\$0}\")' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  # Build the JSON object to send to MongoDB' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  json=\"{\\\"date\\\":\\\"$date\\\",\\\"time\\\":\\\"$time\\\",\\\"level\\\":\\\"$level\\\",\\\"message\\\":\\\"$message\\\"}\"' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  # Send the JSON object to MongoDB using the `mongoimport` command' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  echo $json | mongoimport --uri=$uri --collection=$collection --quiet' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'done' >> /opt/log-forwarder/log-forwarder.sh",
      "chmod +x /opt/log-forwarder/log-forwarder.sh"
    ]
  }
}

# =============================================
#           Monitoring Action Group
# =============================================

resource "azurerm_monitor_action_group" "sentry_azure_action_group" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  # EMAIL CONFIGURATION
  email_receiver {
    name                    = var.action_group_receiver_name
    email_address           = var.action_group_receiver_email
    use_common_alert_schema = true
  }

}

# =============================================
#     Agent Installation and LOG ANALYTICS
# =============================================

module "agent_installation_and_log_analytics_workspace" {
  source                       = "./modules/log_analytics_workspace_and_agent_installation"
  virtual_machine_scale_set_id = var.scaleset_scopes
  resource_group_name          = var.resource_group_name
  location                     = var.location

  #LOG ANALYTICS WORKSPACE
  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_workspace_sku  = var.log_analytics_workspace_sku
  retention_in_days            = var.retention_in_days


  #LOG ANALYTICS SOLUTION
  log_analytics_solution_name = var.log_analytics_solution_name

}


# =============================================
#            Infrastructure Level
# =============================================

# Scaleset Monitoring
module "scaleset_monitoring" {
  source              = "./modules/infrastructure_monitoring/scaleset_monitoring"
  resource_group_name = var.resource_group_name
  scaleset_scopes     = var.scaleset_scopes
  action_group_id     = azurerm_monitor_action_group.sentry_azure_action_group.id

  # CPU ALERT VARS
  scaleset_cpu_description = var.scaleset_cpu_description
  cpu_operator             = var.cpu_operator
  cpu_threshold            = var.cpu_threshold
  cpu_frequency            = var.cpu_frequency
  cpu_severity             = var.cpu_severity
  cpu_window_size          = var.cpu_window_size

  #MEMORY ALERT VARS
  scaleset_memory_description = var.scaleset_memory_description
  memory_operator             = var.memory_operator
  memory_threshold            = var.memory_threshold
  memory_frequency            = var.cpu_frequency
  memory_severity             = var.cpu_severity
  memory_window_size          = var.memory_window_size

}


# Application Gateway Monitoring
# module "application_gateway_monitoring" {
#   source              = "./modules/infrastructure_monitoring/appgateway_monitoring"
#   resource_group_name = var.resource_group_name
#   appgateway_scopes   = var.appgateway_scopes
#   action_group_id     = azurerm_monitor_action_group.sentry_azure_action_group.id

#   # APP GATEWAY RESPONSE STATUS
#   response_status_description = var.response_status_description
#   response_status_operator    = var.response_status_operator
#   response_status_threshold   = var.response_status_threshold
#   response_status_frequency   = var.response_status_frequency
#   response_status_severity    = var.response_status_severity
#   response_status_window_size = var.response_status_window_size

#   # # APP GATEWAY THROUGHPUT
#   # throughput_description = var.throughput_description
#   # throughput_operator    = var.throughput_operator
#   # throughput_threshold   = var.throughput_threshold
#   # throughput_frequency   = var.throughput_frequency
#   # throughput_severity    = var.throughput_severity
#   # throughput_window_size = var.throughput_window_size


#   # APP GATEWAY UNHEALTHY HOST COUNT
#   unhealthy_host_count_description = var.unhealthy_host_count_description
#   unhealthy_host_count_operator    = var.unhealthy_host_count_operator
#   unhealthy_host_count_threshold   = var.unhealthy_host_count_threshold
#   unhealthy_host_count_frequency   = var.unhealthy_host_count_frequency
#   unhealthy_host_count_severity    = var.unhealthy_host_count_severity
#   unhealthy_host_count_window_size = var.unhealthy_host_count_window_size


#   # # APP GATEWAY REQUEST COUNT PER HEALTHY HOST
#   # request_count_description = var.request_count_description
#   # request_count_operator    = var.request_count_operator
#   # request_count_threshold   = var.request_count_threshold
#   # request_count_frequency   = var.request_count_frequency
#   # request_count_severity    = var.request_count_severity
#   # request_count_window_size = var.request_count_window_size

# }

# # MYSQL DATABASE Monitoring
# module "mysql_database_monitoring" {
#   source              = "./modules/infrastructure_monitoring/mysql_database_monitoring"
#   resource_group_name = var.resource_group_name
#   database_scopes     = var.database_scopes
#   action_group_id     = azurerm_monitor_action_group.sentry_azure_action_group.id


#   # MYSQL DATABASE CPU ALERT
#   database_cpu_description = var.database_cpu_description
#   database_cpu_operator    = var.database_cpu_operator
#   database_cpu_threshold   = var.database_cpu_threshold
#   database_cpu_frequency   = var.database_cpu_frequency
#   database_cpu_severity    = var.database_cpu_severity
#   database_cpu_window_size = var.database_cpu_window_size


#   # MYSQL DATABASE STORAGE ALERT
#   database_storage_description = var.database_storage_description
#   database_storage_operator    = var.database_storage_operator
#   database_storage_threshold   = var.database_storage_threshold
#   database_storage_frequency   = var.database_storage_frequency
#   database_storage_severity    = var.database_storage_severity
#   database_storage_window_size = var.database_storage_window_size


#   # # MYSQL DATABASE MEMORY ALERT
#   # database_memory_description = var.database_memory_description
#   # database_memory_operator    = var.database_memory_operator
#   # database_memory_threshold   = var.database_memory_threshold
#   # database_memory_frequency   = var.database_memory_frequency
#   # database_memory_severity    = var.database_memory_severity
#   # database_memory_window_size = var.database_memory_window_size


#   # # MYSQL DATABASE CONNECTION FAILD ALERT
#   # database_connection_faild_description = var.database_connection_faild_description
#   # database_connection_faild_operator    = var.database_connection_faild_operator
#   # database_connection_faild_threshold   = var.database_connection_faild_threshold
#   # database_connection_faild_frequency   = var.database_connection_faild_frequency
#   # database_connection_faild_severity    = var.database_connection_faild_severity
#   # database_connection_faild_window_size = var.database_connection_faild_window_size

# }


