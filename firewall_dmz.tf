#Firewall´s rules for dmz subnet
#Allow trafic in to 80 and 433 ports (http/https) from Internet
resource "azurerm_network_security_rule" "ports_web_dmz" {
  name                        = "ports-web-dmz"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.dmz_group.name
}

resource "azurerm_network_security_rule" "manage_dmz" {
  name                        = "manage-dmz"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_linux_virtual_machine.honeypot_server.public_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.dmz_group.name
}