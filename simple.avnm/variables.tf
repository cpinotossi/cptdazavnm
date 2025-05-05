# ...existing code...

variable "prefix" {
  description = "default name"
  type        = string
  default     = "cptdazavnm"
}

# Define a variable for the subscription ID
variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the Linux virtual machine"
  type        = string
  sensitive   = true
}

variable "admin_user" {
  description = "The admin user for the Linux virtual machine"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "The location for the Azure resources"
  type        = string
  default     = "northeurope" # Optional: Set a default value
}