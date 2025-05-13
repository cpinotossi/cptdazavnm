provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  subscription_id     = var.landingzone_subs["root_1"]
  environment         = "public"
  use_cli             = true
}

provider "azurerm" {
  alias = "root_1"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  environment         = "public"
  use_cli             = true
  subscription_id     = var.landingzone_subs["root_1"]
}

provider "azurerm" {
  alias = "app_lz_1"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  environment         = "public"
  use_cli             = true
  subscription_id     = var.landingzone_subs["app_lz_1"]
}

provider "azurerm" {
  alias = "app_lz_2"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  environment         = "public"
  use_cli             = true
  subscription_id     = var.landingzone_subs["app_lz_2"]
}

provider "azurerm" {
  alias = "sandbox_1"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  environment         = "public"
  use_cli             = true
  subscription_id     = var.landingzone_subs["sandbox_1"]
}

provider "azurerm" {
  alias = "plattform_lz_1"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  environment         = "public"
  use_cli             = true
  subscription_id     = var.landingzone_subs["plattform_lz_1"]
}

provider "azapi" {
  # https://registry.terraform.io/providers/Azure/azapi/latest/docs
  subscription_id = var.landingzone_subs["plattform_lz_1"]
  alias           = "plattform_lz_1"
}

# # Define the management group
# data "azurerm_management_group" "cptdx_net" {
#   name = "cptdx.net"
# }

# # Define the management group
# data "azurerm_management_group" "landingzones" {
#   name = "landingzone"
# }

# # Register the Microsoft.Network provider at the management group scope
# resource "azurerm_provider_registration" "network_provider_registration_cptdx_net" {
#   provider_namespace = "Microsoft.Network"
#   management_group_id = data.azurerm_management_group.cptdx_net.id
# }


# # Register the Microsoft.Network provider at the management group scope
# resource "azurerm_provider_registration" "network_provider_registration_landingzones" {
#   provider_namespace = "Microsoft.Network"
#   management_group_id = data.azurerm_management_group.landingzones.id
# }
