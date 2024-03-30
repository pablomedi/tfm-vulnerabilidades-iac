resource "azurerm_resource_group" "resource_gp" {
    name = "TFM"
    location ="North Europe"

}

variable "prefix" {
  default = "tfm"
}
