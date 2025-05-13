output "vnet_id" {
  description = "The ID of the created Virtual Network"
  value       = azurerm_virtual_network.spoke_vnet.id
}

output "subnet_id" {
  description = "The ID of the created Subnet"
  value       = azurerm_subnet.spoke_subnet.id
}