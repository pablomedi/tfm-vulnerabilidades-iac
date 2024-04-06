resource "azurerm_virtual_network" "corporative_network" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
}

resource "azurerm_subnet" "external_subnet" {
  name                 = "${var.prefix}-external-subnet"
  resource_group_name  = azurerm_resource_group.resource_gp.name
  virtual_network_name = azurerm_virtual_network.corporative_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "dmz_subnet" {
  name                 = "${var.prefix}-dmz-subnet"
  resource_group_name  = azurerm_resource_group.resource_gp.name
  virtual_network_name = azurerm_virtual_network.corporative_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "internal_subnet" {
  name                 = "${var.prefix}-internal-subnet"
  resource_group_name  = azurerm_resource_group.resource_gp.name
  virtual_network_name = azurerm_virtual_network.corporative_network.name
  address_prefixes     = ["10.0.3.0/24"]
}