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
resource "azapi_resource" "aca-test-environment" {
  name      = "aca-test-environment"
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  location  = var.location
  parent_id = azurerm_resource_group.aca-test-rg.id
  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.aca-test-ws.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.aca-test-ws.primary_shared_key
        }
      }
    }
  })
}

resource "azapi_resource" "producer_container_app" {
  name      = "producer-containerapp"
  location  = var.location
  parent_id = azurerm_resource_group.aca-test-rg.id
  type      = "Microsoft.App/containerApps@2022-03-01"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.aca-test-environment.id
      configuration = {
        ingress = {
          targetPort = 80
          external   = true
        },
        registries = [
          {
            server            = azurerm_container_registry.aca-test-registry.login_server
            username          = azurerm_container_registry.aca-test-registry.admin_username
            passwordSecretRef = "registry-password"
          }
        ],
        secrets : [
          {
            name = "registry-password"
            # Todo: Container apps does not yet support Managed Identity connection to ACR
            value = azurerm_container_registry.aca-test-registry.admin_password
          }
        ]
      },
      template = {
        containers = [
          {
            image = "${azurerm_container_registry.aca-test-registry.login_server}/${var.producer_image_name}:latest"
            name  = "producer",
            env : [
              {
                "name" : "EnvVariable",
                "value" : "Value"
              }
            ]
          }
        ]
      }
    }
  })
  # This seems to be important for the private registry to work(?)
  ignore_missing_property = true
  response_export_values = ["properties.configuration.ingress"]
}

