resource "azurerm_network_security_rule" "internal_to_kali_allow" {
  name                        = "internal-to-kali-allow"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.internal_group.name
}

resource "azurerm_network_security_rule" "internal_to_world_allow" {
  name                        = "internal-to-world-allow"
  priority                    = 101
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.internal_group.name
}