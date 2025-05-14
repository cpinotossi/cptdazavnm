data "azurerm_subscription" "subscription" {
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.prefix
}

resource "azurerm_resource_group" "rg_root" {
  location = var.location
  name     = "${var.prefix}root"
  provider = azurerm.root_1
}
resource "azurerm_resource_group" "rg_plattform_lz_1" {
  location = var.location
  name     = "${var.prefix}platform1"
  provider = azurerm.plattform_lz_1
}
resource "azurerm_resource_group" "rg_app_lz_1" {
  location = var.location
  name     = "${var.prefix}app1"
  provider = azurerm.app_lz_1
}
resource "azurerm_resource_group" "rg_app_lz_2" {
  location = var.location
  name     = "${var.prefix}app2"
  provider = azurerm.app_lz_2
}
resource "azurerm_resource_group" "rg_sandbox_1" {
  location = var.location
  name     = "${var.prefix}sandbox1"
  provider = azurerm.sandbox_1
}