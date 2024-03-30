resource "azurerm_linux_virtual_machine" "kali_linux" {
  name                            = "${var.prefix}-kali-linux"
  location                        = azurerm_resource_group.resource_gp.location
  resource_group_name             = azurerm_resource_group.resource_gp.name
  network_interface_ids           = [azurerm_network_interface.kali_interface.id]
  size                            = var.size
  admin_username                  = var.kali_username
  admin_password                  = var.kali_password
  disable_password_authentication = false
  custom_data                     = filebase64("./config_scripts/config_kali.sh")

  os_disk {
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = "kali-2023-4"
    version   = "latest"
  }

  plan {
    name      = "kali-2023-4"
    publisher = "kali-linux"
    product   = "kali"
  }
}