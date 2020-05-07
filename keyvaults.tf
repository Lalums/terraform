#Create 2 key vaults required for doorman application and corda with Standard and Premium tier

resource "azurerm_key_vault" "mykeyvault1" {
  name                = "${element(var.keyvaultnames,0)}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  sku {
    name = "standard"
  }
  tenant_id = "${var.tenant_id}"
}

resource "azurerm_key_vault" "mykeyvault2" {
  name                = "${element(var.keyvaultnames,1)}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  sku {
    name = "premium"
  }
  tenant_id = "${var.tenant_id}"
}

resource "azurerm_key_vault" "mykeyvault3" {
  name                = "${element(var.keyvaultnames,2)}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  sku {
    name = "premium"
  }
  tenant_id = "${var.tenant_id}"
}