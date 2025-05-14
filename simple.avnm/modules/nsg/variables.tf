variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

variable "location" {
  description = "Location of the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "allow_icmp" {
  description = "Whether to allow or deny ICMP traffic"
  type        = string
  default     = "Allow"
}

variable "subnet_id" {
  description = "List of subnet IDs to associate with the NSG"
  type        = string
}