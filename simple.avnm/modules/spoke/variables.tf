variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of the Subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the Subnet"
  type        = list(string)
}

variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
}

variable "admin_user" {
  description = "The admin username for the Virtual Machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the Virtual Machine"
  type        = string
}

# variable "cidrs" {
#   description = "CIDR blocks for the VNet and Subnet"
#   type        = map(string)
# }

variable "source_image" {
  description = "Source image details for the Virtual Machine"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
