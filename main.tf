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
  resource_group_name = var.ResourceGroup
  location            = var.Location
  sku                 = "PerGB2018"
  retention_in_days   = 90 
}
resource "azapi_resource" "aca" {
  for_each  = { for ca in var.container_apps: ca.name => ca}
  type      = "Microsoft.App/containerApps@2022-03-01"
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location
  name      = each.value.name
  
  body = jsonencode({
    properties: {
      managedEnvironmentId = azapi_resource.aca_env.id
      configuration = {
        ingress = {
          external = each.value.ingress_enabled
          targetPort = each.value.ingress_enabled?each.value.containerPort: null
        }
      }
      template = {
        containers = [
          {
            name = "main"
            image = "${each.value.image}:${each.value.tag}"
            resources = {
              cpu = each.value.cpu_requests
              memory = each.value.mem_requests
            }
          }         
        ]
        scale = {
          minReplicas = each.value.min_replicas
          maxReplicas = each.value.max_replicas
        }
      }
    }
  })
}
