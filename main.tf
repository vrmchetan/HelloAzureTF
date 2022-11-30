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

