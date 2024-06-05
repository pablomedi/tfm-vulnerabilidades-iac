#Security groups for each subnet
resource "azurerm_network_security_group" "dmz_group" {
  name                = "${var.prefix}-dmz-group"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
}

resource "azurerm_network_security_group" "external_group" {
  name                = "${var.prefix}-external-group"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
}

resource "azurerm_network_security_group" "internal_group" {
  name                = "${var.prefix}-internal-group"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
}

#Unions subnets with security groups 
resource "azurerm_subnet_network_security_group_association" "externalnal_attached" {
  subnet_id                 = azurerm_subnet.external_subnet.id
  network_security_group_id = azurerm_network_security_group.external_group.id
}

resource "azurerm_subnet_network_security_group_association" "dmz_attached" {
  subnet_id                 = azurerm_subnet.dmz_subnet.id
  network_security_group_id = azurerm_network_security_group.dmz_group.id
}

resource "azurerm_subnet_network_security_group_association" "internal_attached" {
  subnet_id                 = azurerm_subnet.internal_subnet.id
  network_security_group_id = azurerm_network_security_group.internal_group.id
}