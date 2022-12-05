resource "azurerm_resource_group" "example" {
  name     = "nitikumarsinghh"
  location = "West Europe"
}

resource "azurerm_container_group" "example" {
  name                = "nitikumarsinghh"
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

  container {
    name   = "sidecar"
    image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
  # Create a resource group
  resource "azurerm_resource_group" "rg" {
  name     = "rg"
  location = "West Europe"
  tags =  {
  env = "dev"
  cost = "TA102AXY"
  }
}
resource "azurerm_container_registry" "acr" {
  name                = "containerRegistry543456"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
 }
}
