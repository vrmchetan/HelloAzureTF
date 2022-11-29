resource "azurerm_resource_group" "example" {
  name     = "terra-resource"
  location = "West Europe"
}

resource "azurerm_virtual_network" "main" {
  name                = "terra-network"
  address_space       = ["10.0.0.0/16"]
  location            = West Europe
  resource_group_name = terra-resource
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = terra-resource
  virtual_network_name = terra-network
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "terra-interface-nic"
  location            = West Europe
  resource_group_name = terra-resource

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "terra-vm"
  location              = West Europe
  resource_group_name   = terra-resource
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
}
