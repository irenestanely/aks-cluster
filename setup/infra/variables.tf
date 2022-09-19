variable "location" {
  description = "The Azure region to deploy in"
  default     = "eastus"
}

variable "env" {
  description = "Environment running this infrastructure"
  default     = "ubuntu"
}

variable "spoke_resource_group_name" {
  description = "The spoke resource group name, which will contain the k8s controlplane and worker nodes"
  default     = "tinyedge-kubelet-sample-rg"
}

variable "spoke_vnet_name" {
  description = "The spoke virtual network name"
  default     = "tinyedge-vnet"
} 

variable "vm_size" {
  description = "Default VM size for controlplane and worker nodes"
  default     = "Standard_D2_v2"
}

variable "vm_user" {
  description = "Admin user name - same for all VM's"
  type        = string
  default     = "tinyedge"
}

# variable "workspace-root" {
#   type        = string
#   description = "The github workspace root directory"
# }

# variable "device_cs" {
#   type        = string
#   description = "The IOT hub device connection string"
# }

# variable "acr_password" {
#   type        = string
#   description = "The Azure container registry password"
# }