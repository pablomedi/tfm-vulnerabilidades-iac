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