resource "azurerm_lb" "lb" {
  name                = "konsch-lb"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.lb.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "lb" {
	name					= "konsch-lb-address-pool"
	resource_group_name		= "${azurerm_resource_group.test.name}"
	loadbalancer_id			= "${azurerm_lb.lb.id}"
}

resource "azurerm_public_ip" "lb" {
  name                         = "konsch-lb-PublicIp"
  location                     = "${azurerm_resource_group.test.location}"
  resource_group_name          = "${azurerm_resource_group.test.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_lb_rule" "lb" {
	name					= "konsch-lb-rule"
	resource_group_name            = "${azurerm_resource_group.test.name}"
    loadbalancer_id                = "${azurerm_lb.lb.id}"
	protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "PublicIPAddress"
}
