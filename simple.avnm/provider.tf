provider "azurerm" {

  features {
  }
  # use_oidc = false
  # skip_provider_registration = true
  storage_use_azuread = true
  subscription_id     = var.subscription_id
  environment         = "public"
  # use_msi         = false
  use_cli = true
}
