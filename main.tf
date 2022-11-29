resource "azurerm_resource_group" "resourcegroups" {
    name        = var.ResourceGroup
    location    = var.Location
}

resource "azurerm_virtual_machine" "main" {
  name                  = "terra-vm"
  location              = var.Location
  resource_group_name   = var.ResourceGroup
  network_interface_ids = terraform-github276
  vm_size               = "Standard_DS1_v2"
}
