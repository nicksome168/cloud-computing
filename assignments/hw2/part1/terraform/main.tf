variable "resource_group_location" {}
variable "rg_name" {}
variable "storage_ac_name" {}
variable "prefix" {}

resource "azurerm_resource_group" "rg" {
    location = var.resource_group_location
    name = var.rg_name
}

resource "azurerm_storage_account" "storage_ac" {
  name                     = var.storage_ac_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.prefix}-nic-config"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_D2s_v3"

  storage_os_disk {
    name              = "${var.prefix}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  storage_image_reference {
    publisher = "datasciencedojo1586563145740"
    offer     = "jupyter1"
    sku       = "jupyterplanbasic"
    version   = "1.0.0"
  }
  plan {
    name = "jupyterplanbasic"
    publisher = "datasciencedojo1586563145740"
    product = "jupyter1"
  }
  os_profile {
    computer_name = "${var.prefix}-vm"
    admin_username = "${var.prefix}-admin"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ssh_key.public_key_openssh
      path = "/home/${var.prefix}-admin/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_network_security_group" "sg" {
  name                = "${var.prefix}-sg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "${var.prefix}-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.sg.id
}


resource "tls_private_key" "ssh_key" {
    algorithm = "RSA"
    rsa_bits = 2048
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "private.pem"
  file_permission = "0600"
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}