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

resource "azurerm_network_interface" "kali_interface" {
  name                = "${var.prefix}-kali-interface"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name

  ip_configuration {
    name                          = "kali-network"
    subnet_id                     = azurerm_subnet.external_subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.kali_ip.id
  }
}

resource "azurerm_public_ip" "kali_ip" {
  name                = "${var.prefix}-kali-ip"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
  allocation_method   = var.allocation_method
}

resource "azurerm_network_interface" "dvwa_interface" {
  name                = "${var.prefix}-dvwa-interface"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name

  ip_configuration {
    name                          = "dvwa-network"
    subnet_id                     = azurerm_subnet.dmz_subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.dvwa_ip.id
  }
}

resource "azurerm_public_ip" "dvwa_ip" {
  name                = "${var.prefix}-dvwa-ip"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
  allocation_method   = var.allocation_method
  domain_name_label = "tfm2024"
}