resource "azurerm_resource_group" "rg" {
    name     = "terra-resource-001"
    location = "West Europe"
    }
resource "azurerm_log_analytics_workspace" "law" {
    name                = "terra-acctest-01"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
    }
resource "azurerm_container_app_env" "example" {
    name                   = "terra-containerapp-env"
    location               = azurerm_resource_group.rg.location
    resource_group_name    = azurerm_resource_group.rg.name
    logs_workspace_id      = azurerm_log_analytics_workspace.law.id
    logs-workspace-key     = azurerm_log_analytics_workspace.law.secret
    }
resource "azurerm_container_registry" "acr" {
    name                = "containerRegistry1"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    sku                 = "Premium"
    admin_enabled       = false
    }
resource "azurerm_container_app" "aca" {
    name                   = "containerapp"
    resource_group_name    = azurerm_resource_group.rg.name
    environment            = "azurerm_container_app_env.example.environment"
    image                  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
    target_port            = 80
    ingress                = "external"
    query                  = "configuration.ingress.fqdn"
    }
resource "azurerm_container_group" "acg" {
    name                = "terra-acg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_address_type     = "Public"
    os_type             = "Linux"

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

