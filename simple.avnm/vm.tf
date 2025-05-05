# resource "azurerm_linux_virtual_machine" "res-2" {
#   admin_password                  = var.admin_password
#   admin_username                  = "chpinoto"
#   disable_password_authentication = false
#   location                        = azurerm_resource_group.rg.location
#   name                            = "cptdazavnm1"
#   network_interface_ids           = ["/subscriptions/${var.subscription_id}/resourceGroups/cptdazavnm/providers/Microsoft.Network/networkInterfaces/cptdazavnm1675"]
#   resource_group_name             = "cptdazavnm"
#   secure_boot_enabled             = true
#   size                            = "Standard_B2as_v2"
#   vtpm_enabled                    = true
#   zone                            = "1"
#   additional_capabilities {
#   }
#   boot_diagnostics {
#   }
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_reference {
#     offer     = "ubuntu-24_04-lts"
#     publisher = "canonical"
#     sku       = "server"
#     version   = "latest"
#   }
#   depends_on = [
#     azurerm_network_interface.res-6,
#   ]
# }
# resource "azurerm_network_interface" "nic" {
#   enable_accelerated_networking = true
#   location                      = azurerm_resource_group.rg.location
#   name                          = "cptdazavnm1675"
#   resource_group_name           = "cptdazavnm"
#   ip_configuration {
#     name                          = "ipconfig1"
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = "/subscriptions/${var.subscription_id}/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke1/subnets/subnet1"
#   }
#   depends_on = [
#     # One of azurerm_subnet.res-33,azurerm_subnet_route_table_association.res-34 (can't auto-resolve as their ids are identical)
#   ]
# }