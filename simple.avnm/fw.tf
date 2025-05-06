resource "azurerm_firewall" "firewall" {
#   firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id
  location            = azurerm_resource_group.rg.location
  name                = var.prefix
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  ip_configuration {
    name                 = "${var.prefix}fw"
    public_ip_address_id = azurerm_public_ip.public_ip_fw.id
    subnet_id            = azurerm_subnet.hub1_subnet_firewall.id
  }
  management_ip_configuration {
    name                 = "${var.prefix}fwm"
    public_ip_address_id = azurerm_public_ip.public_ip_fw_mgmt.id
    subnet_id            = azurerm_subnet.hub1_subnet_firewall_mgmt.id
  }
}

# resource "azurerm_firewall_policy" "firewall_policy" {
#   location            = azurerm_resource_group.rg.location
#   name                = var.prefix
#   resource_group_name = "cptdazavnm"
# }

resource "azurerm_public_ip" "public_ip_fw" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "${var.prefix}fw"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}
resource "azurerm_public_ip" "public_ip_fw_mgmt" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = "${var.prefix}fwm"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

