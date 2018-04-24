provider "azurerm" {

}

terraform {
  backend "azurerm" {
    resource_group_name = "jambitiac"
    storage_account_name = "jambitiac"
    container_name       = "tfstate"
    key = "konsch.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "konsch" {
	name = "konsch"
	location = "westeurope"
}