resource "azurerm_virtual_network" "spoke2_vnet" {
  name                = "spoke2applz"
  location            = azurerm_resource_group.rg_app_lz_2.location
  resource_group_name = azurerm_resource_group.rg_app_lz_2.name
  address_space       = ["${var.cidrs["spoke2"]}"]
  tags = {
    trusted   = "true"
    vnet_type = "spoke"
  }
  provider = azurerm.app_lz_2
}
resource "azurerm_subnet" "spoke2_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg_app_lz_2.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
  address_prefixes     = ["${var.cidrs["spoke2_subnet_0_default"]}"]
  provider             = azurerm.app_lz_2
}

module "spoke2_vm" {
  source                 = "git::https://github.com/cpinotossi/cptdtfazmodules.git//virtual-machine-linux"
  resource_group         = azurerm_resource_group.rg_app_lz_2.name
  name                   = "${var.prefix}s2"
  subnet_id              = azurerm_subnet.spoke2_subnet.id
  location               = azurerm_resource_group.rg_app_lz_2.location
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
  depends_on             = [azurerm_subnet.spoke2_subnet]
  admin_principal_id     = data.azurerm_client_config.current.object_id
  providers = {
    azurerm.default = azurerm.app_lz_2
  }
}

module "spoke2_nsg" {
  source              = "./modules/nsg"
  nsg_name            = "spoke2-nsg"
  location            = azurerm_resource_group.rg_app_lz_2.location
  resource_group_name = azurerm_resource_group.rg_app_lz_2.name
  allow_icmp          = var.allow_icmp
  subnet_ids          = [azurerm_subnet.spoke2_subnet.id]
  providers = {
    azurerm.default = azurerm.app_lz_2
  }
}

