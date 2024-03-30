output "ip_kali_linux" {
  value = azurerm_linux_virtual_machine.kali_linux.public_ip_address
}
