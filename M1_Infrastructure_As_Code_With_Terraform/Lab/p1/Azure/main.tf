terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=3.0.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_public_ip" "vm1pip" {
    name = "vm1pip"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    allocation_method = "Dynamic"
}

resource "azurerm_resource_group" "rg" {
    name = "rg-terraform"
    location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
    name = "internal"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vm1nic" {
    name = "vm1nic"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.snet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.vm1pip.id
    }
}

resource "azurerm_linux_virtual_machine" "vm1" {
    name = "vm1"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    size = "Standard_B1s"
    disable_password_authentication = "false"
    admin_username = "adminuser"
    admin_password = "TerraformRulez!"
    network_interface_ids = [
        azurerm_network_interface.vm1nic.id,
    ]

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }
}

output "public_ip" {
    value = azurerm_linux_virtual_machine.vm1.public_ip_address
}
