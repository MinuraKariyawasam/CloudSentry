# IMPORTANT: Most of these threshold are universal, so no need to change. 
# However,if this monitoring solution did not optimize with the production-level application, 
# you can change these values manually from the here.

# Severity - The severity of the alert after the criteria specified in the alert rule is met. Severity can range from 0 to 4.
# You can find out attribute values from here: https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-overview


# GLOBAL VARS
resource_group_name = "dev-stentry"
location = "East US 2"

scaleset_count = 1
application_count = 0
database_count = 0

# =============================================
#         Application Logs Monitoring
# =============================================

vm_host = "10.0.2.7"

vm_user = "azureuser"

vm_password = "kN@ldoWds0o1"

bastion_host = "20.22.191.63"

bastion_user = "azureuser"

bastion_password = "kN@ldoWds0o1"

log_forwarder_url = "/var/log/dev.log"
# mongodb+srv://minurakariyawasaminfo:RyQ3jWW2ZbttOFYD@cluster0.nfyfngf.mongodb.net/?retryWrites=true&w=majority
mongo_db_uri = "mongodb+srv://minurakariyawasaminfo:RyQ3jWW2ZbttOFYD@cluster0.nfyfngf.mongodb.net/centry_logs?retryWrites=true&w=majority"

# =======================================================
#                    ACTION GROUP
# =======================================================

action_group_name = "sentry_action_group"
action_group_short_name = "ALERTS"
action_group_receiver_name = "minura"
action_group_receiver_email = "cloudsentry.alerts@gmail.com"

# =======================================================
#                  LOG ANALYTICS WORKSPACE
# =======================================================

log_analytics_workspace_name = "sentryLogAnalytics"
log_analytics_workspace_sku = "PerGB2018"
retention_in_days = 30

# =======================================================
#                  LOG ANALYTICS SOLUTION
# =======================================================

log_analytics_solution_name = "ContainerInsights"


# =======================================================
#                  SCALESET MONITORING
# =======================================================

# You can find out the related values and attribute unit used to create scaleset metric alert here
# https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftcomputevirtualmachinescalesets

# GLOBAL VARS
scaleset_scopes = "/subscriptions/17ba3673-bc1b-4edf-ab24-cb18637b44b9/resourceGroups/dev-stentry/providers/Microsoft.Compute/virtualMachineScaleSets/vmscaleset"

# CPU ALERT VARS
cpu_operator = "GreaterThan"
cpu_threshold = 1
cpu_frequency = "PT5M"
cpu_severity = 1
cpu_window_size = "PT15M"

# MEMORY ALERT VARS
memory_operator = "GreaterThan"
memory_threshold = 70
memory_frequency = "PT5M"
memory_severity = 1
memory_window_size = "PT15M"

# =======================================================
#            APPLICATION GATEWAY MONITORING
# =======================================================

# You can find out the related values and attribute unit used to create Application Gateway metric alert here
# https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftnetworkapplicationgateways

# GLOBAL VARS
appgateway_scopes = ["/subscriptions/17ba3673-bc1b-4edf-ab24-cb18637b44b9/resourceGroups/dev-stentry/providers/Microsoft.Network/applicationGateways/dev-app"]
                    
# APP GATEWAY RESPONSE STATUS
response_status_operator = "GreaterThan"
response_status_threshold = 1
response_status_frequency = "PT5M"
response_status_severity = 2
response_status_window_size = "PT15M"


# APP GATEWAY UNHEALTHY HOST COUNT
unhealthy_host_count_operator = "GreaterThan"
unhealthy_host_count_threshold = 2
unhealthy_host_count_frequency = "PT5M"
unhealthy_host_count_severity = 1
unhealthy_host_count_window_size = "PT15M"

# =======================================================
#            MYSQL DATABASE MONITORING
# =======================================================

# You can find out the related values and attribute unit used to create MySQL Server metric alert here
# https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftdbformysqlservers

# GLOBAL VARS 
database_scopes = ["/subscriptions/17ba3673-bc1b-4edf-ab24-cb18637b44b9/resourceGroups/dev-stentry/providers/Microsoft.Sql/servers/dev-sql-test-uow/databases/dev-sql"]

# MYSQL DATABASE CPU ALERT
database_cpu_operator = "GreaterThan"
database_cpu_threshold = 1
database_cpu_frequency = "PT5M"
database_cpu_severity = 2
database_cpu_window_size = "PT15M"


# MYSQL DATABASE STORAGE ALERT
database_storage_operator = "GreaterThan"
database_storage_threshold = 2
database_storage_frequency = "PT5M"
database_storage_severity = 1
database_storage_window_size = "PT15M"
