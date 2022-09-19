module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

resource "azurerm_public_ip" "cluster_vm_pip" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "cluster_vm_nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "vmNicConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cluster_vm_pip.id
  }
}

resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  # provisioner "local-exec" { # Generate "terraform-key-pair.pem" in current directory
  #   command = <<-EOT
  #     mkdir -p ~/.ssh && touch ~/.ssh/id_rsa.pem
  #     echo '${tls_private_key.ssh-key.private_key_pem}' > ~/.ssh/id_rsa.pem
  #     chmod 400 ~/.ssh/id_rsa.pem
  #   EOT
  # }
}

resource "azurerm_network_security_group" "cluster_vm_nsg" {
  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = module.myip.address
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "cluster_vm" {
  name                            = "${var.name}-vm"
  location                        = var.location
  resource_group_name             = var.resource_group
  network_interface_ids           = [azurerm_network_interface.cluster_vm_nic.id]
  size                            = "Standard_B4ms"
  computer_name                   = var.name
  admin_username                  = var.vm_user
  disable_password_authentication = true

  os_disk {
    name                 = "${var.name}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    #public_key = file(var.ssh_public_key_path)
    public_key = tls_private_key.ssh-key.public_key_openssh
    username   = var.vm_user
  }
}

resource "local_file" "public_key" {
  content         = tls_private_key.ssh-key.public_key_openssh
  filename        = "${terraform.workspace}/${var.name}_id_rsa.pub"
  file_permission = "0400"
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh-key.private_key_pem
  filename        = "${terraform.workspace}/${var.name}_id_rsa.pem"
  file_permission = "0400"
}