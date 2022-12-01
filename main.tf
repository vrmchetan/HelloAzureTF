resource "azurerm_resource_group" "resourcegroups" {
    name        = var.ResourceGroup
    location    = var.Location
}
resource "azurerm_container_registry" "acr" {
  name                = "appinventivkumar"
  resource_group_name = var.ResourceGroup
  location            = var.Location
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
resource "azapi_resource"  "aca" {
    type       = "Microsoft.App/containerApp@2022-03-01"
    parent_id  = azurerm_resource_group.resourcegroups.id
    location   = var.Location
    name       = "terraform-app007"

    body = jsonencode({
        properties : {
            managedEnvironmentId  = azapi_resource.aca_env.id
            configuration = {
                ingress = {
                    external  = true
                    targetPort = 80
                }
            }
        }
        template = {
            containers = [
                {
                    name = "web"
                    image = "ngnix"
                    resource = {
                        cpu = 0.5
                        memory = "1.0Gi "
                    }
                }
            ]
            scale = {
                minReplicas = 2
                maxReplicas = 20
            }
        }
    })
 }

