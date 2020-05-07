 # Creating Loadbalancers for Corda Vms
 resource "azurerm_lb" "LB" {
  count = 8
  name                = "${element(var.lbNames, count.index)}"
  location            = "northeurope"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${element(azurerm_public_ip.mypips1.*.id, count.index)}"
  }
}
resource "azurerm_lb_backend_address_pool" "cordabackendpool" {
  count = 8
  resource_group_name     = "${azurerm_resource_group.myresourcegroup.name}"
  loadbalancer_id         = "${element(azurerm_lb.LB.*.id, count.index)}"
  name                    = "BackendPool1"
}

#Rule for SSH
resource "azurerm_lb_nat_rule" "mytcprule1" {
count = 8
  resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
  loadbalancer_id                = "${element(azurerm_lb.LB.*.id, count.index)}"
  name                           = "SSH"
  protocol                       = "tcp"
  frontend_port                  = "22"
  backend_port                   = "22"
  frontend_ip_configuration_name = "PublicIPAddress"
  #count                          = 1
}

#Rule for 80
resource "azurerm_lb_nat_rule" "mytcprule2" {
count = 8
  resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
  loadbalancer_id                = "${element(azurerm_lb.LB.*.id, count.index)}"
  name                           = "Webhttp"
  protocol                       = "tcp"
  frontend_port                  = "80"
  backend_port                   = "80"
  frontend_ip_configuration_name = "PublicIPAddress"
  #count                          = 1
}

#Rule for AMQP
resource "azurerm_lb_nat_rule" "mytcprule3" {
count = 8
  resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
  loadbalancer_id                = "${element(azurerm_lb.LB.*.id, count.index)}"
  name                           = "AMQP"
  protocol                       = "tcp"
  frontend_port                  = "10002"
  backend_port                   = "10002"
  frontend_ip_configuration_name = "PublicIPAddress"
  #count                          = 1
}

#Create Loadbalancer for DNS VMs
resource "azurerm_lb" "dnslb" {
  name                = "dns-lb"
  location            = "northeurope"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.mypips2.id}"
  }
}
  resource "azurerm_lb_backend_address_pool" "dnsbackendpool" {
    resource_group_name     = "${azurerm_resource_group.myresourcegroup.name}"
    loadbalancer_id         = "${azurerm_lb.dnslb.id}"
    name                    = "DNSBackendPool"
  }
  
  #Rule for RDP
  resource "azurerm_lb_nat_rule" "dnsrdp" {
    resource_group_name          = "${azurerm_resource_group.myresourcegroup.name}"
    loadbalancer_id                = "${azurerm_lb.dnslb.id}"
    name                           = "RDP-VM-${count.index}"
    protocol                       = "tcp"
    frontend_port                  = "5000${count.index + 1}"
    backend_port                   = "3389"
    frontend_ip_configuration_name = "PublicIPAddress"
    count                          = 2
  }




  