#Remote backend to store statefiles so that all contributors work on the same configuration without conflicts
terraform {
  backend "azurerm" {
    resource_group_name  = "ratheesh"
    storage_account_name = "statefilefolder"
    container_name       = "statefiles"
    key                  = "statefiles.terraform.tfstate"
    access_key           = "KdBW0I5QalLgses2KuK9kVSqiebQa9PlZdkgFZ3OA87JICjvKeAIuXtdMpVbm4TqYqsqEWH2R7a4wNfPIeK4Vw=="
  }
}
