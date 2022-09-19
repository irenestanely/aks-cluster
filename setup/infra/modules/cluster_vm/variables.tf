variable "name" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_id" {
  description = "ID of the VNET where jumpbox VM will be installed"
  type        = string
}

variable "subnet_id" {
  description = "ID of subnet where jumpbox VM will be installed"
  type        = string
}

variable "vm_user" {
  description = "Admin user name"
  type        = string
  default     = "irenes"
}

variable "ssh_public_key_path" {
  description = "Path to ssh public key used to SSH into jumpbox"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}