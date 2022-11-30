resource "azurerm_resource_group" "resourcegroups" {
    name        = var.ResourceGroup
    location    = var.Location
}
resource "azurerm_container_registry" "acr" {
  name                = "containerRegistry1"
  resource_group_name = azurerm_resource_group
  location            = azurerm_resource_group
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                = azurerm_resource_group
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = azurerm_resource_group
    zone_redundancy_enabled = true
    tags                    = {}
  }
}
