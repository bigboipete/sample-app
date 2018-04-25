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

resource "azurerm_resource_group" "test" {
	name = "konsch-rg"
	location = "westeurope"
}

# 'data' verwaltet nicht wie 'resource', sondern ermöglicht leidglich Zugirff
data "azurerm_resource_group" "image" {
  name = "jambitiac"
}

data "azurerm_image" "image" {
  name                = "konsch_j8_packer_image"
  resource_group_name = "${data.azurerm_resource_group.image.name}" # Könnte auch einfach nur 'jambitiac' sein
}

resource "azurerm_availability_set" "test" {
  name                			= "acceptanceTestAvailabilitySet"
  location            			= "${azurerm_resource_group.test.location}"
  resource_group_name 			= "${azurerm_resource_group.test.name}"
  platform_update_domain_count	= "2"
  platform_fault_domain_count	= "2"
  managed			  			= "true"
}

resource "azurerm_virtual_network" "test" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "test" {
  name                 = "acctsub"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.2.0/24"
}

