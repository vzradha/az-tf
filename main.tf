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

resource "azurerm_network_interface" "taurus_nic" {
  name                = "taurus-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.subnet[0].id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_private_dns_zone" "taurus_dns" {
  name = "taurus.example.com"
  resource_group_name =  azurerm_resource_group.rg.name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example_kv" {
  name                = "vra-test-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# Key Vault Secret with a specific version
resource "azurerm_key_vault_secret" "example_secret" {
  name         = "my-secret"
  value        = "super_secret_value"
  key_vault_id = azurerm_key_vault.example_kv.id
}
# Key Vault Secret with a specific version
resource "azurerm_key_vault_secret" "localadmin" {
  name         = "localadmin"
  value        = "localadmin"
  key_vault_id = azurerm_key_vault.example_kv.id
}
resource "azurerm_key_vault_secret" "localadmin_password" {
  name         = "localadmin-password"
  value        = "localadmin"
  key_vault_id = azurerm_key_vault.example_kv.id
}


