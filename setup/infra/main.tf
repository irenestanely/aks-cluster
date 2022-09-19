terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "random_integer" "unique_naming" {
  max = 999
  min = 1
}

resource "azurerm_resource_group" "spoke_rg" {
  name     = "${var.spoke_resource_group_name}-${random_integer.unique_naming.id}"
  location = var.location
}

module "spoke_virtual_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.spoke_rg.name
  location            = azurerm_resource_group.spoke_rg.location
  vnet_name           = var.spoke_vnet_name
  address_space       = ["10.0.1.0/24"]
  subnets = [
    {
      name : "controlplane-subnet"
      address_prefixes : ["10.0.1.0/26"]
    },
    {
      name : "worker-subnet"
      address_prefixes : ["10.0.1.64/26"]
    }
  ]
}
module "storage_account" {
  source         = "./modules/storage_account"
  location       = azurerm_resource_group.spoke_rg.location
  resource_group = azurerm_resource_group.spoke_rg.name
}

module "controlplane" {
  source         = "./modules/cluster_vm"
  name           = "controlplane"
  vm_user        = var.vm_user
  resource_group = azurerm_resource_group.spoke_rg.name
  location       = azurerm_resource_group.spoke_rg.location
  vnet_id        = module.spoke_virtual_network.vnet_id
  subnet_id      = module.spoke_virtual_network.subnet_ids["controlplane-subnet"]
}

module "node01" {
  source         = "./modules/cluster_vm"
  name           = "node01"
  vm_user        = var.vm_user
  resource_group = azurerm_resource_group.spoke_rg.name
  location       = azurerm_resource_group.spoke_rg.location
  vnet_id        = module.spoke_virtual_network.vnet_id
  subnet_id      = module.spoke_virtual_network.subnet_ids["worker-subnet"]
}

module "node02" {
  source         = "./modules/cluster_vm"
  name           = "node02"
  vm_user        = var.vm_user
  resource_group = azurerm_resource_group.spoke_rg.name
  location       = azurerm_resource_group.spoke_rg.location
  vnet_id        = module.spoke_virtual_network.vnet_id
  subnet_id      = module.spoke_virtual_network.subnet_ids["worker-subnet"]
}

module "jumpbox" {
  source         = "./modules/cluster_vm"
  name           = "jumpbox"
  vm_user        = var.vm_user
  resource_group = azurerm_resource_group.spoke_rg.name
  location       = azurerm_resource_group.spoke_rg.location
  vnet_id        = module.spoke_virtual_network.vnet_id
  subnet_id      = module.spoke_virtual_network.subnet_ids["worker-subnet"]

}

resource "azurerm_virtual_machine_extension" "jumpbox_ext" {
  name                 = "jumpbox_ext${random_integer.unique_naming.id}"
  virtual_machine_id   = module.jumpbox.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "pwd"
    }
  SETTINGS
}










