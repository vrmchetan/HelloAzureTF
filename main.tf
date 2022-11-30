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
  name                = "law-aca-terraform"
  resource_group_name = var.ResourceGroup
  location            = var.Location
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = "terra-1234"
}

