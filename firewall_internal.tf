#Block kibana in dmz
resource "azurerm_network_security_rule" "port_kibana_elasticsearch_block" {
  name                        = "internal_kibana_elasticsearch_port_block"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["5601", "9200"]
  source_address_prefix       = azurerm_linux_virtual_machine.dvwa_server.public_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.internal_group.name
}

#Allow kibana
resource "azurerm_network_security_rule" "port_kibana_elasticsearch" {
  name                        = "internal_kibana_elasticsearch_port"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["5601", "9200"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.internal_group.name
}

#Allow ssh cowrie
resource "azurerm_network_security_rule" "ssh_honeypot" {
  name                        = "ssh_honeypot"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "2222"
  source_address_prefix       = azurerm_linux_virtual_machine.kali_linux.public_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_gp.name
  network_security_group_name = azurerm_network_security_group.internal_group.name
}