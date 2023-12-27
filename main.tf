resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "azurerm_virtual_network" "taurus" {
  name = "taurus-network"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["172.20.0.0/16"]
  dns_servers = ["172.20.0.4", "172.20.0.5"]

  subnet {
    name = "taurus-subnet1"
    address_prefix = "172.20.1.0/24"
  }

  subnet {
    name = "taurus-subnet2"
    address_prefix = "172.20.2.0/24"
  }

}

resource "azurerm_dns_zone" "taurus_dns" {
  name = "taurus.example.com"
  resource_group_name =  azurerm_resource_group.rg.name
}