resource "azurerm_virtual_network" "hub1_vnet" {
  address_space       = ["${var.cidrs["hub1"]}"]
  location            = azurerm_resource_group.rg_plattform_lz_1.location
  name                = "hub0"
  resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
  provider            = azurerm.plattform_lz_1
}
resource "azurerm_subnet" "hub1_subnet_firewall_mgmt" {
  address_prefixes     = ["${var.cidrs["hub1_subnet_2_firewall_Mgmt"]}"]
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg_plattform_lz_1.name
  virtual_network_name = azurerm_virtual_network.hub1_vnet.name
  provider             = azurerm.plattform_lz_1
}
resource "azurerm_subnet" "hub1_subnet_firewall" {
  address_prefixes     = ["${var.cidrs["hub1_subnet_1_firewall"]}"]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_plattform_lz_1.name
  virtual_network_name = azurerm_virtual_network.hub1_vnet.name
  provider             = azurerm.plattform_lz_1
}
resource "azurerm_subnet" "hub1_subnet" {
  address_prefixes     = ["${var.cidrs["hub1_subnet_0_default"]}"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg_plattform_lz_1.name
  virtual_network_name = azurerm_virtual_network.hub1_vnet.name
  provider             = azurerm.plattform_lz_1
}

resource "azurerm_subnet" "hub1_subnet_bastion" {
  address_prefixes     = ["${var.cidrs["hub1_subnet_3_bastion"]}"]
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_plattform_lz_1.name
  virtual_network_name = azurerm_virtual_network.hub1_vnet.name
  provider             = azurerm.plattform_lz_1
}

module "hub1_bastion" {
  source              = "git::https://github.com/cpinotossi/cptdtfazmodules.git//bastion-host"
  resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
  location            = azurerm_resource_group.rg_plattform_lz_1.location
  name                = "${var.prefix}h1bastion"
  subnet_id           = azurerm_subnet.hub1_subnet_bastion.id
  providers = {
    azurerm.default = azurerm.plattform_lz_1
  }
}

module "hub1_vm" {
  source                 = "git::https://github.com/cpinotossi/cptdtfazmodules.git//virtual-machine-linux"
  resource_group         = azurerm_resource_group.rg_plattform_lz_1.name
  name                   = "${var.prefix}h1"
  subnet_id              = azurerm_subnet.hub1_subnet.id
  location               = azurerm_resource_group.rg_plattform_lz_1.location
  zone                   = "1"
  vm_size                = var.vm_size
  source_image_publisher = var.source_image_publisher
  source_image_offer     = var.source_image_offer
  source_image_sku       = var.source_image_sku
  source_image_version   = var.source_image_version
  username               = var.admin_user
  password               = var.admin_password
  use_vm_custom_data     = false
  custom_data            = base64encode("python3 -m http.server")
  depends_on             = [azurerm_subnet.hub1_subnet]
  admin_principal_id     = data.azurerm_client_config.current.object_id
  providers = {
    azurerm.default = azurerm.plattform_lz_1
  }
}