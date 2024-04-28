#Output display after deploy environment
output "ip_kali_linux" {
  value = azurerm_linux_virtual_machine.kali_linux.public_ip_address
}

output "ip_dvwa_server" {
  value = azurerm_linux_virtual_machine.dvwa_server.public_ip_address
}

output "ip_honeypot" {
  value = azurerm_linux_virtual_machine.honeypot_server.public_ip_address
}

output "dns_dvwa_server" {
  value = azurerm_public_ip.dvwa_ip.fqdn
}