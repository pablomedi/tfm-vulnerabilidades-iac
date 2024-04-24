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
  domain_name_label   = "tfm2024"
}

resource "azurerm_network_interface_security_group_association" "dmz_security_group" {
  network_interface_id      = azurerm_network_interface.dvwa_interface.id
  network_security_group_id = azurerm_network_security_group.dmz_group.id
}

resource "azurerm_linux_virtual_machine" "dvwa_server" {
  name                            = "${var.prefix}-dvwa-server"
  location                        = azurerm_resource_group.resource_gp.location
  resource_group_name             = azurerm_resource_group.resource_gp.name
  network_interface_ids           = [azurerm_network_interface.dvwa_interface.id]
  size                            = var.size
  admin_username                  = var.dvwa_username
  admin_password                  = var.dvwa_password
  disable_password_authentication = false
  custom_data                     = filebase64("./config_scripts/config_dvwa.sh")

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