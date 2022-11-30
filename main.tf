resource "azurerm_resource_group" "resourcegroups" {
    name        = var.ResourceGroup
    location    = var.Location
}
resource "azurerm_container_registry" "acr" {
  name                = "containerRegistry1"
  resource_group_name = var.ResourceGroup
  location            = var.Location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                = "North Europe"
    zone_redundancy_enabled = true
    tags                    = {}
  }
  
}
