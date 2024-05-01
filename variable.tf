#Variables about azure account
variable "subscription_id" {
  description = "Subscription Id de Azure"
}

variable "client_id" {
  description = "Client Id of Azure"
}

variable "client_secret" {
  description = "Client secret of Azure"
}

variable "tenant_id" {
  description = "Tenant Id of Azure"
}

#Variables about machines
variable "size" {
  description = "Specifications of the virtual machine"
}

variable "size_honeypot" {
  description = "Specifications of the virtual machine honeypot"
}

variable "caching" {
  description = "Type of internal caching OS Disk"
}

variable "storage_account_type" {
  description = "Type of internal caching OS Disk"
}

#Variables about networks
variable "private_ip_address_allocation" {
  description = "Allocation method for private ip address"
}

variable "allocation_method" {
  description = "Allocation method for ip address"
}

#Variables about users and passwords
variable "kali_username" {
  description = "User for Kali Linux machine"
}

variable "kali_password" {
  description = "Password for user Kali Linux machine"
}

variable "dvwa_username" {
  description = "User for DVWA server machine"
}

variable "dvwa_password" {
  description = "Password for user DVWA server machine"
}

variable "honeypot_username" {
  description = "User for honeypot machine"
}

variable "honeypot_password" {
  description = "Password for user honeypot machine"
}