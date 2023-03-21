# -----------------------------------------------------
#              Log Analytics Workspace
# -----------------------------------------------------

resource "azurerm_log_analytics_workspace" "la" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.retention_in_days
}

# -----------------------------------------------------
#              Log Analytics Solution
# -----------------------------------------------------

resource "azurerm_log_analytics_solution" "ls" {
  solution_name         = var.log_analytics_solution_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.la.id
  workspace_name        = azurerm_log_analytics_workspace.la.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}


# -----------------------------------------------------
#              Agent Installation
# -----------------------------------------------------

resource "azurerm_virtual_machine_scale_set_extension" "oms_agnet" {
  name                         = "OMSExtension"
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  publisher                    = "Microsoft.EnterpriseCloud.Monitoring"
  type                         = "OmsAgentForLinux"
  type_handler_version         = "1.12"
  #auto_upgrade_minor_version   = true

  settings = <<SETTINGS
    {
      "workspaceId" : "${azurerm_log_analytics_workspace.la.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey" : "${azurerm_log_analytics_workspace.la.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_scale_set_extension" "da_agent" {
  name                         = "DAExtension"
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  publisher                    = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                         = "DependencyAgentLinux"
  type_handler_version         = "9.5"
  #auto_upgrade_minor_version   = true

}
