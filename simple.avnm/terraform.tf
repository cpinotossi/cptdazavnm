terraform {
  backend "local" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.27.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
}
