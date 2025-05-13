terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      configuration_aliases = [ azurerm.default ]
    }
  }
}

# Create an NSG
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  provider = azurerm.default
}

# Add an inbound rule to allow or deny ICMP (ping)
resource "azurerm_network_security_rule" "allow_icmp_inbound" {
  resource_group_name         = var.resource_group_name
  name                        = "Allow-ICMP-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = var.allow_icmp
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*" # Adjust to your source range
  destination_address_prefix  = "*" # Adjust to your destination range
  network_security_group_name = azurerm_network_security_group.nsg.name
  provider = azurerm.default
}

# Add an outbound rule to allow or deny ICMP (ping)
resource "azurerm_network_security_rule" "allow_icmp_outbound" {
  resource_group_name         = var.resource_group_name
  name                        = "Allow-ICMP-Outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = var.allow_icmp
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*" # Adjust to your source range
  destination_address_prefix  = "*" # Adjust to your destination range
  network_security_group_name = azurerm_network_security_group.nsg.name
  provider = azurerm.default
}

# Associate the NSG with subnets
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = toset(var.subnet_ids)

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg.id
  provider = azurerm.default
}