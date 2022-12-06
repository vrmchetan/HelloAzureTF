resource "azurerm_resource_group" "example" {
    name     = "terra-resource-001"
    location = "West Europe"
    }
resource "azurerm_log_analytics_workspace" "example" {
    name                = "terra-acctest-01"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
    }
resource "azurerm_container_app_env" "example" {
    name                   = "terra-containerapp-env"
    location               = azurerm_resource_group.example.location
    resource_group_name    = azurerm_resource_group.example.name
    logs_workspace_id      = "logsworkspaceclientid"
    logs-workspace-key     = "logsworkspaceclientsecret"
    }
resource "azurerm_container_registry" "acr" {
    name                = "containerRegistry1"
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_resource_group.example.location
    sku                 = "Premium"
    admin_enabled       = false
    }
resource "azurerm_container_app" "example" {
    name                   = "containerapp"
    resource_group_name    = "resourcegroupname"
    environment            = "azurerm_container_app_env.example.environment"
    image                  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
    target_port            = 80
    ingress                = "external"
    query                  = "configuration.ingress.fqdn"
    }
resource "azurerm_container_group" "example" {
    name                = "terra-acg"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
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

