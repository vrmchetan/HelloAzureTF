resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = abcd1234
  resource_group_name   = test-resource
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
