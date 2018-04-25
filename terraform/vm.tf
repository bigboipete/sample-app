resource "azurerm_public_ip" "test" {
  count						   = "${var.sample-app-count}"
  name                         = "acceptanceTestPublicIp-${count.index}"
  location                     = "${azurerm_resource_group.test.location}"
  resource_group_name          = "${azurerm_resource_group.test.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "test" {
  # 'count' beschreibt, wie oft instanziiert wird. Die Variable liefert nur den Wert der Anzahl.
  count				  = "${var.sample-app-count}"
  name                = "acctni-${count.index}"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  ip_configuration {
	name                          = "testconfiguration-${count.index}"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.test.*.id[count.index]}"
	load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.lb.id}"]
  }
}

resource "azurerm_virtual_machine" "test" {
  count				    = "${var.sample-app-count}"
  name                  = "konsch-sample-app-vm-${count.index}"
  location              = "${azurerm_resource_group.test.location}"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  # '*': Alle network interfaces aus der Liste (=> count) der erstellten NIs
  network_interface_ids = ["${azurerm_network_interface.test.*.id[count.index]}"]
  availability_set_id	= "${azurerm_availability_set.test.id}"
  vm_size               = "Standard_A0"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  storage_image_reference {
    id="${data.azurerm_image.image.id}"
  }

  storage_os_disk {
    name              = "myosdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "konsch-j8-${count.index}"
    admin_username = "jambitadmin"
    admin_password = "jambit123#!#!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}