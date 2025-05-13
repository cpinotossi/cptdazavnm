variable "allow_icmp" {
  description = "Allow ICMP traffic"
  type        = string
  default     = "Allow"
}

variable "cidrs" {
  description = "Configuration for the Virtual Machines"
  type        = map(string)
  default = {
    hub1_summary_cidr           = "10.0.0.0/8"
    hub1                        = "10.0.0.0/16"
    hub1_subnet_0_default       = "10.0.0.0/24"
    hub1_subnet_1_firewall      = "10.0.1.0/24"
    hub1_subnet_2_firewall_Mgmt = "10.0.2.0/24"
    hub1_subnet_3_bastion       = "10.0.3.0/24"
    spoke1                      = "10.1.0.0/16"
    spoke1_subnet_0_default     = "10.1.0.0/24"
    spoke2                      = "10.2.0.0/16"
    spoke2_subnet_0_default     = "10.2.0.0/24"
    spoke3                      = "10.3.0.0/16"
    spoke3_subnet_0_default     = "10.3.0.0/24"
  }
}

variable "landingzone_subs" {
  description = "Subscription to Landingzone mapping"
  type        = map(string)
  default = {
    root_1         = "4b353dc5-a216-485d-8f77-a0943546b42c" # sub-05
    app_lz_1       = "11c61beb-b32b-4166-9d6c-74cb3a2e04da" # sub-08
    app_lz_2       = "65668fbe-24d6-410e-b9b7-b9e52a499caf" # sub-09
    sandbox_1      = "7777febc-d5d8-44da-b990-643c8369f1e1" # sub-06
    plattform_lz_1 = "d3856ecd-977c-4651-ab8a-8208fe79dfac" # sub-04
  }
}

variable "source_image" {
  description = "Source image configuration"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "prefix" {
  description = "default name"
  type        = string
  default     = "cptdazavnm"
}

# # Define a variable for the subscription ID
# variable "subscription_id" {
#   description = "The Azure subscription ID"
#   type        = string
# }

variable "management_group_root_id" {
  description = "The Azure Management Group ID"
  type        = string
  # default     = "/providers/Microsoft.Management/managementGroups/cptdx.net"
  default = "/providers/Microsoft.Management/managementGroups/cptdx.net"
}
variable "management_group_landingzones_id" {
  description = "The Azure Management Group ID"
  type        = string
  default     = "/providers/Microsoft.Management/managementGroups/landingzones"
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

variable "eu_regions" {
  description = "List of European regions for network manager deployments"
  type        = list(string)
  default     = ["westeurope", "northeurope"] # Example regions
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_D2as_v6" # Optional: Set a default value
}

variable "source_image_publisher" {
  description = "source image reference publisher"
  type        = string
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "source image reference offer"
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "source_image_sku" {
  description = "source image reference sku"
  type        = string
  default     = "server"
}

variable "source_image_version" {
  description = "source image reference version"
  type        = string
  default     = "latest"
}

# variable "logAnalyticsWorkspaceName" {
#   description = "logAnalyticsWorkspaceName name"
#   type        = string
# }

variable "avnm_regions" {
  description = "List of Azure regions for AVNM deployments"
  type        = list(string)
  default     = ["eastus", "westus", "centralus", "northeurope", "westeurope", "southeastasia", "australiaeast", "japaneast", "brazilsouth"]
}