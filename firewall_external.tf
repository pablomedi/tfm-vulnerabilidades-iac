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
