# =============================================
#         CLOUDSENTRY Monitoring Solution
# =============================================

# =============================================
#         Application Logs Monitoring
# =============================================

resource "azurerm_virtual_machine_scale_set_extension" "app_log_forwarder" {
  name                         = "app-log-forwarder"
  virtual_machine_scale_set_id = var.scaleset_scopes
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.1"
  settings                     = <<SETTINGS
    {
      "fileUris": ["/opt/log-forwarder/log-forwarder.sh"]
    }
  SETTINGS

  provisioner "remote-exec" {
    connection {
      type             = "ssh"
      host             = var.vm_host
      user             = var.vm_user
      password         = var.vm_password
      agent            = false
      timeout          = "5m"
      bastion_host     = var.bastion_host
      bastion_user     = var.bastion_user
      bastion_password = var.bastion_password
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
      "echo \"uri='${var.mongo_db_uri}'\" >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '# Set the name of the database and collection to store logs' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'database=\"centry_logs\"' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'collection=\"app_logs\"' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'server_hostname=$(hostname)' >> /opt/log-forwarder/log-forwarder.sh",
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
      "echo '  document=\"{\\\"date\\\":\\\"$date\\\",\\\"time\\\":\\\"$time\\\",\\\"level\\\":\\\"$level\\\",\\\"message\\\":\\\"$message\\\",\\\"server_hostname\\\":\\\"$server_hostname\\\"}\"' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  # Send the JSON object to MongoDB using the `mongoimport` command' >> /opt/log-forwarder/log-forwarder.sh",
      "echo '  mongo $uri/$database --username minurakariyawasaminfo --password RyQ3jWW2ZbttOFYD --eval \"db.$collection.insertOne($document)\" > /dev/null' >> /opt/log-forwarder/log-forwarder.sh",
      "echo 'done' >> /opt/log-forwarder/log-forwarder.sh",
      "chmod +x /opt/log-forwarder/log-forwarder.sh",

      "echo '#!/bin/bash' >> /opt/log-forwarder/setup-cronjob.sh",
      "echo 'LOG_FORWARDER_SCRIPT=\"/opt/log-forwarder/log-forwarder.sh\"' >> /opt/log-forwarder/setup-cronjob.sh",
      "echo 'CRON_JOB_COMMAND=\"* * * * * /bin/bash $LOG_FORWARDER_SCRIPT\"' >> /opt/log-forwarder/setup-cronjob.sh",
      "echo '(crontab -l ; echo \"$CRON_JOB_COMMAND\") | crontab -' >> /opt/log-forwarder/setup-cronjob.sh",
      "chmod +x /opt/log-forwarder/setup-cronjob.sh",
      "/bin/bash /opt/log-forwarder/setup-cronjob.sh"
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
  count               = var.scaleset_count
  source              = "./modules/infrastructure_monitoring/scaleset_monitoring"
  resource_group_name = var.resource_group_name
  scaleset_scopes     = var.scaleset_scopes
  action_group_id     = azurerm_monitor_action_group.sentry_azure_action_group.id

  # CPU ALERT VARS
  scaleset_cpu_description = "Action will be triggered when SCALESET CPU is ${var.cpu_operator} ${var.cpu_threshold}%\n"
  cpu_operator             = var.cpu_operator
  cpu_threshold            = var.cpu_threshold
  cpu_frequency            = var.cpu_frequency
  cpu_severity             = var.cpu_severity
  cpu_window_size          = var.cpu_window_size

  #MEMORY ALERT VARS
  scaleset_memory_description = "Action will be triggered when SCALESET MEMORY is ${var.memory_operator} ${var.memory_threshold}%\n"
  memory_operator             = var.memory_operator
  memory_threshold            = var.memory_threshold
  memory_frequency            = var.cpu_frequency
  memory_severity             = var.cpu_severity
  memory_window_size          = var.memory_window_size

}


# Application Gateway Monitoring
module "application_gateway_monitoring" {
  count               = var.application_count
  source              = "./modules/infrastructure_monitoring/appgateway_monitoring"
  resource_group_name = var.resource_group_name
  appgateway_scopes   = var.appgateway_scopes
  action_group_id     = azurerm_monitor_action_group.sentry_azure_action_group.id

  # APP GATEWAY RESPONSE STATUS
  response_status_description = "Action will be triggered when GATEWAY RESPONSE STATUS is ${var.response_status_operator} ${var.response_status_threshold}%\n"
  response_status_operator    = var.response_status_operator
  response_status_threshold   = var.response_status_threshold
  response_status_frequency   = var.response_status_frequency
  response_status_severity    = var.response_status_severity
  response_status_window_size = var.response_status_window_size


  # APP GATEWAY UNHEALTHY HOST COUNT
  unhealthy_host_count_description = "Action will be triggered when GATEWAY UNHEALTHY HOST COUNT is ${var.unhealthy_host_count_operator} ${var.unhealthy_host_count_threshold}%\n"
  unhealthy_host_count_operator    = var.unhealthy_host_count_operator
  unhealthy_host_count_threshold   = var.unhealthy_host_count_threshold
  unhealthy_host_count_frequency   = var.unhealthy_host_count_frequency
  unhealthy_host_count_severity    = var.unhealthy_host_count_severity
  unhealthy_host_count_window_size = var.unhealthy_host_count_window_size

}

# MYSQL DATABASE Monitoring
module "mysql_database_monitoring" {
  count               = var.database_count
  source              = "./modules/infrastructure_monitoring/mysql_database_monitoring"
  resource_group_name = var.resource_group_name
  database_scopes     = var.database_scopes
  action_group_id     = azurerm_monitor_action_group.sentry_azure_action_group.id


  # MYSQL DATABASE CPU ALERT
  database_cpu_description = "Action will be triggered when DATABASE CPU is ${var.database_cpu_operator} ${var.database_cpu_threshold*100}%\n"
  database_cpu_operator    = var.database_cpu_operator
  database_cpu_threshold   = var.database_cpu_threshold
  database_cpu_frequency   = var.database_cpu_frequency
  database_cpu_severity    = var.database_cpu_severity
  database_cpu_window_size = var.database_cpu_window_size


  # MYSQL DATABASE STORAGE ALERT
  database_storage_description = "Action will be triggered when DATABASE STORAGE is ${var.database_storage_operator} ${var.database_storage_threshold}%\n"
  database_storage_operator    = var.database_storage_operator
  database_storage_threshold   = var.database_storage_threshold
  database_storage_frequency   = var.database_storage_frequency
  database_storage_severity    = var.database_storage_severity
  database_storage_window_size = var.database_storage_window_size

}


