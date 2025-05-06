provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
  subscription_id     = var.subscription_id
  environment         = "public"
  use_cli             = true
}

provider "azapi" {
  # https://registry.terraform.io/providers/Azure/azapi/latest/docs
  subscription_id     = var.subscription_id
}