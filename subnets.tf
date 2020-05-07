#Create Subnets
  resource "azurerm_subnet" "mysubnet1" {
  name = "mgmt"
  address_prefix = "10.1.1.0/24"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myvnet.name}"
  #network_security_group_id = "${azurerm_network_security_group.MYManagement-nsg.id}"
  }
  resource "azurerm_subnet" "mysubnet2" {
  name = "agw"
  address_prefix = "10.1.2.0/24"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myvnet.name}"
  #network_security_group_id = "${azurerm_network_security_group.MYAPPGW-nsg.id}"
  }
 
  resource "azurerm_subnet" "mysubnet4" {
  name = "apim"
  address_prefix = "10.1.4.0/24"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myvnet.name}"
  #network_security_group_id = "${azurerm_network_security_group.MYapim-nsg.id}"
  }  
  resource "azurerm_subnet" "mysubnet5" {
  name = "corda"
  address_prefix = "10.1.5.0/24"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myvnet.name}"
  #network_security_group_id = "${azurerm_network_security_group.MYCorda-nsg.id}"
  service_endpoints    = ["Microsoft.Sql"]
  }
