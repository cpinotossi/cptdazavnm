resource "azurerm_virtual_network" "spoke1_vnet" {
  name                = "spoke1"
  location            = azurerm_resource_group.rg_app_lz_1.location
  resource_group_name = azurerm_resource_group.rg_app_lz_1.name
  address_space       = ["${var.cidrs["spoke1"]}"]
  tags = {
    vnet_type = "trusted"
  }
  provider = azurerm.app_lz_1
}
resource "azurerm_subnet" "spoke1_subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg_app_lz_1.name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
  address_prefixes     = ["${var.cidrs["spoke1_subnet_0_default"]}"]
  provider             = azurerm.app_lz_1
}

module "spoke1_vm" {
  source                 = "git::https://github.com/cpinotossi/cptdtfazmodules.git//virtual-machine-linux"
  resource_group         = azurerm_resource_group.rg_app_lz_1.name
  name                   = "${var.prefix}s1"
  subnet_id              = azurerm_subnet.spoke1_subnet.id
  location               = azurerm_resource_group.rg_app_lz_1.location
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
  depends_on             = [azurerm_subnet.spoke1_subnet]
  admin_principal_id     = data.azurerm_client_config.current.object_id
  providers = {
    azurerm.default = azurerm.app_lz_1
  }
}

module "spoke1_nsg" {
  source              = "./modules/nsg"
  nsg_name            = "spoke1-nsg"
  location            = azurerm_resource_group.rg_app_lz_1.location
  resource_group_name = azurerm_resource_group.rg_app_lz_1.name
  allow_icmp          = var.allow_icmp
  subnet_id           = azurerm_subnet.spoke1_subnet.id
  providers = {
    azurerm.default = azurerm.app_lz_1
  }
  depends_on = [
    azurerm_subnet.spoke1_subnet
  ]
}

