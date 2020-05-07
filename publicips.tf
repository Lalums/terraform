#public ips to be used in this environment

#8 public ips to be assigned to nics in corda subnet
resource "azurerm_public_ip" "mypips1" {
  count = 8
  name                         = "${element(var.pipnames, count.index)}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${element(var.domainnames, count.index)}"
}


#1 public ips to be assigned to nics in management subnet
resource "azurerm_public_ip" "mypips2" {
  count = 1
  name                         = "${element(var.pipnames, 8)}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${element(var.domainnames, 8)}"
}

#1 public ips to be assigned to nics in management subnet
resource "azurerm_public_ip" "mypips4" {
  count = 1
  name                         = "${element(var.pipnames, 9)}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${element(var.domainnames, 9)}"
}




#1 public ips to be assigned to Application gateway in application gateway subnet
resource "azurerm_public_ip" "mypips3" {
  count = 1
  name                         = "${element(var.pipnames, 10)}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
  public_ip_address_allocation = "dynamic"
}






