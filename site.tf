# Create a resource group
resource "azurerm_resource_group" "myresourcegroup" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}

# Create virtual network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.vnetname}"
  address_space       = ["10.1.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"

}
