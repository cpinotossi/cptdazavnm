resource "azurerm_virtual_network" "hub_vnet" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  name                = "hub0"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "hub_subnet_firewall_mgmt" {
  address_prefixes     = ["10.0.2.0/24"]
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
}
resource "azurerm_subnet" "hub_subnet_firewall" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
}
resource "azurerm_subnet" "hub_subnet" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
}

resource "azurerm_virtual_network" "spoke1_vnet" {
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  name                = "spoke1"
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    trusted  = "true"
    vnet_type = "spoke"
  }
}
resource "azurerm_subnet" "spoke1_subnet" {
  address_prefixes     = ["10.1.0.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
}

resource "azurerm_virtual_network" "spoke2_vnet" {
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.rg.location
  name                = "spoke2"
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    trusted  = "true"
    vnet_type = "spoke"
  }
}
resource "azurerm_subnet" "spoke2_subnet" {
  address_prefixes     = ["10.2.0.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
}

resource "azurerm_virtual_network" "spoke3_vnet" {
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.rg.location
  name                = "spoke3"
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    trusted  = "false"
    vnet_type = "spoke"
  }
}
resource "azurerm_subnet" "spoke3_subnet" {
  address_prefixes     = ["10.3.0.0/24"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke3_vnet.name
}
