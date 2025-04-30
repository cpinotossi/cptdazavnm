provider "azurerm" {
  features {
  }
  use_oidc                   = false
  skip_provider_registration = true
  subscription_id            = "4896a771-b1ab-4411-bd94-3c8467f1991e"
  environment                = "public"
  use_msi                    = false
  use_cli                    = true
}
