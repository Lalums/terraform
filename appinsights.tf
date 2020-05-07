#Creating APP Insights
  

resource "azurerm_application_insights" "myappinisghts" {
  name                = "${var.appinsname}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myresourcegroup.name}"
  application_type    = "Web"
}

output "instrumentation_key" {
  value = "${azurerm_application_insights.myappinisghts.instrumentation_key}"
}

output "app_id" {
  value = "${azurerm_application_insights.myappinisghts.app_id}"
}