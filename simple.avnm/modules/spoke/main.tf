resource "azurerm_virtual_network" "spoke_vnet" {
  address_space       = var.vnet_address_space
  location            = var.location
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  tags = {
    trusted   = "true"
    vnet_type = "spoke"
  }
}

resource "azurerm_subnet" "spoke_subnet" {
  address_prefixes     = var.subnet_address_prefixes
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
}

module "spoke_vm" {
  source                 = "git::https://github.com/cpinotossi/cptdtfazmodules.git//virtual-machine-linux"
  resource_group         = var.resource_group_name
  name                   = var.vm_name
  subnet_id              = azurerm_subnet.spoke_subnet.id
  location               = var.location
  zone                   = "1"
  vm_size                = var.vm_size
  source_image_publisher = var.source_image.publisher
  source_image_offer     = var.source_image.offer
  source_image_sku       = var.source_image.sku
  source_image_version   = var.source_image.version
  username               = var.admin_user
  password               = var.admin_password
  use_vm_custom_data     = false
  custom_data            = base64encode("python3 -m http.server")
  depends_on             = [azurerm_subnet.spoke_subnet]
}