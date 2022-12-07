
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "0.4.0"
    }  
  }
}
 provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "example" {
    name     = "terra-resource-001"
    location = "West Europe"
    }
