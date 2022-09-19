output "vm_id" {
  description = "Generated VM ID"
  value       = azurerm_linux_virtual_machine.cluster_vm.id
}

output "vm_private_ip_address" {
  value = azurerm_linux_virtual_machine.cluster_vm.private_ip_address
}

output "vm_public_ip_address" {
  value = azurerm_linux_virtual_machine.cluster_vm.public_ip_address
}

output "pi" {
  value = tls_private_key.ssh-key.private_key_pem
}

output "ssh_public_key" {
  value     = tls_private_key.ssh-key.public_key_openssh
  sensitive = true
}

output "ssh_private_key" {
  value     = tls_private_key.ssh-key.private_key_pem
  sensitive = true
}


