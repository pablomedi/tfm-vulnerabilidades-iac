resource "azurerm_network_interface" "kali_interface" {
  name                = "${var.prefix}-kali-interface"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name

  ip_configuration {
    name                          = "kali-network"
    subnet_id                     = azurerm_subnet.external_subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.kali_ip.id
  }
}

resource "azurerm_public_ip" "kali_ip" {
  name                = "${var.prefix}-kali-ip"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
  allocation_method   = var.allocation_method
}

resource "azurerm_network_interface_security_group_association" "external_security_group" {
  network_interface_id      = azurerm_network_interface.kali_interface.id
  network_security_group_id = azurerm_network_security_group.external_group.id
}

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