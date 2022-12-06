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

resource "azurerm_container_registry" "example" {
    name                = "testalpacontainerRegistry1"
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_resource_group.example.location
    sku                 = "Premium"
    admin_enabled       = false
    }

resource "azurerm_container_group" "example" {
  name                = "example-continst"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_address_type     = "Public"
  dns_name_label      = "aci-label"
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

  container {
    name   = "sidecar"
    image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
}
