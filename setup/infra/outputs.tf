output "jumpbox_public_ip_address" {
  value = module.jumpbox.vm_public_ip_address
}

output "controlplane_private_ip_address" {
  value = module.controlplane.vm_private_ip_address
}

output "controlplane_public_ip_address" {
  value = module.controlplane.vm_public_ip_address
}

output "jumpbox_privatekey" {
  value     = module.jumpbox.ssh_private_key
  sensitive = true
}

output "vm_user" {
  value = var.vm_user
}