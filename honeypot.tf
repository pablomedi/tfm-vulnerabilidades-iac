#Network interface of honeypot
resource "azurerm_network_interface" "honeypot_interface" {
  name                = "${var.prefix}-honeypot-interface"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name

  ip_configuration {
    name                          = "honeypot-network"
    subnet_id                     = azurerm_subnet.internal_subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.honeypot_ip.id
  }
}

#Public ip of honeypot
resource "azurerm_public_ip" "honeypot_ip" {
  name                = "${var.prefix}-honeypot-ip"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
  allocation_method   = var.allocation_method
}

#Union of interface with security group external
resource "azurerm_network_interface_security_group_association" "internal_security_group" {
  network_interface_id      = azurerm_network_interface.honeypot_interface.id
  network_security_group_id = azurerm_network_security_group.internal_group.id
}

#Virtual machine honeypot with Ubuntu, Cowrie, Elasticsearch, Kibana, Logstash
resource "azurerm_linux_virtual_machine" "honeypot_server" {
  name                            = "${var.prefix}-honeypot"
  location                        = azurerm_resource_group.resource_gp.location
  resource_group_name             = azurerm_resource_group.resource_gp.name
  network_interface_ids           = [azurerm_network_interface.honeypot_interface.id]
  size                            = var.size_honeypot
  admin_username                  = var.honeypot_username
  admin_password                  = var.honeypot_password
  disable_password_authentication = false
  custom_data                     = filebase64("./config_scripts/config_honeypot.sh")

  os_disk {
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}