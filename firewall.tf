#Firewall´s rules for external subnet
#Allow all trafic in
resource "azurerm_network_security_rule" "all_trafic_in_external" {
  name                        = "all-trafic-in-allow-external"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.external_group.name
}

#Allow all trafic out
resource "azurerm_network_security_rule" "all_trafic_out_external" {
  name                        = "all-trafic-out-allow-external"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.external_group.name
}

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
