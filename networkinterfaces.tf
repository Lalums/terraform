# Create all network interfaces required for this environment

# 8 Nics to be assigned to Management subnemycordavmst
resource "azurerm_network_interface" "mynics" {
  count = 1
  name                      = "cordanic${count.index+1}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.myresourcegroup.name}"
  depends_on = ["azurerm_resource_group.myresourcegroup","azurerm_virtual_network.myvnet","azurerm_subnet.mysubnet5"]

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = "${azurerm_subnet.mysubnet5.id}"
    private_ip_address_allocation = "dynamic"
    }
}

#Create NIC for DNS VM
resource "azurerm_network_interface" "mydnsnic" {
  count = 1
  name = "dnsnic${count.index+1}"
  location = "${azurerm_resource_group.myresourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  ip_configuration {
  name = "dnsipconfig"
  subnet_id = "${azurerm_subnet.mysubnet1.id}"
  private_ip_address_allocation = "dynamic"
  }
}