resource "azurerm_resource_group" "resourcegroups" {
    name        = var.ResourceGroup
    location    = var.Location
}
resource "azurerm_container_registry" "acr" {
  name                = "a1"
  resource_group_name = azurerm_resource_group.resourcegroups.name
  location            = azurerm_resource_group.resourcegroups.location
  sku                 = "Basic"
  admin_enabled       = false
}
resource "azurerm_log_analytics_workspace" "law" {
  name                = "aca-env-terraform"
  resource_group_name = azurerm_resource_group.resourcegroups.name
  location            = azurerm_resource_group.resourcegroups.location
  sku                 = "PerGB2018"
  retention_in_days   = 90 
}
# creating aca environment
resource "azapi_resource" "aca_env" {
     type       = "Microsoft.App/managedEnvironments@2022-03-01"
     parent_id  = azurerm_resource_group.resourcegroups.id
     location = var.Location
     name = "aca-env-terraform"
     schema_validation_enabled = false
     
     body = jsonencode({
        properties = {
            appLogsConfiguration = {
                destination = "log-analytics"
                logAnalyticsConfiguration = {
                    customerId = azurerm_log_analytics_workspace.law.workspace_id 
                    sharedKey  = azurerm_log_analytics_workspace.law.primary_shared_key
                }
            }
        }

    })

}


#creating the aca
resource "azapi_resource" "container_app" {
    type       = "Microsoft.App/containerApps@2022-03-01"
    parent_id  = azurerm_resource_group.resourcegroups.id
    location   = azurerm_resource_group.resourcegroups.location
    name       = "aca-test-environments"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  
}
}

