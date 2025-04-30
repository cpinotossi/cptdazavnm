resource "azurerm_virtual_machine_extension" "res-0" {
  auto_upgrade_minor_version = true
  name                       = "MDE.Linux"
  publisher                  = "Microsoft.Azure.AzureDefenderForServers"
  settings = jsonencode({
    autoUpdate        = true
    azureResourceId   = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/CPTDAZAVNM/providers/Microsoft.Compute/virtualMachines/cptdazavnm1"
    forceReOnboarding = false
    vNextEnabled      = false
  })
  type                 = "MDE.Linux"
  type_handler_version = "1.0"
  virtual_machine_id   = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/CPTDAZAVNM/providers/Microsoft.Compute/virtualMachines/cptdazavnm1"
  depends_on = [
    azurerm_linux_virtual_machine.res-2,
  ]
}
resource "azurerm_resource_group" "res-1" {
  location = "northeurope"
  name     = "cptdazavnm"
}
resource "azurerm_linux_virtual_machine" "res-2" {
  admin_password                  = "ignored-as-imported"
  admin_username                  = "chpinoto"
  disable_password_authentication = false
  location                        = "northeurope"
  name                            = "cptdazavnm1"
  network_interface_ids           = ["/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/networkInterfaces/cptdazavnm1675"]
  resource_group_name             = "cptdazavnm"
  secure_boot_enabled             = true
  size                            = "Standard_B2as_v2"
  vtpm_enabled                    = true
  zone                            = "1"
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "canonical"
    sku       = "server"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-6,
  ]
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "res-3" {
  daily_recurrence_time = "1900"
  location              = "northeurope"
  timezone              = "UTC"
  virtual_machine_id    = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Compute/virtualMachines/cptdazavnm1"
  notification_settings {
    enabled = false
  }
  depends_on = [
    azurerm_linux_virtual_machine.res-2,
  ]
}
resource "azurerm_firewall" "res-4" {
  firewall_policy_id  = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/firewallPolicies/cptdazavnm"
  location            = "northeurope"
  name                = "cptdazavnm"
  resource_group_name = "cptdazavnm"
  sku_name            = "AZFW_VNet"
  sku_tier            = "Basic"
  ip_configuration {
    name                 = "cptdazavnmfw"
    public_ip_address_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/publicIPAddresses/cptdazavnmfw"
    subnet_id            = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0/subnets/AzureFirewallSubnet"
  }
  management_ip_configuration {
    name                 = "cptdazavnmfwm"
    public_ip_address_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/publicIPAddresses/cptdazavnmfwm"
    subnet_id            = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0/subnets/AzureFirewallManagementSubnet"
  }
  depends_on = [
    azurerm_firewall_policy.res-5,
    azurerm_public_ip.res-12,
    azurerm_subnet.res-16,
    azurerm_subnet.res-17,
  ]
}
resource "azurerm_firewall_policy" "res-5" {
  location            = "northeurope"
  name                = "cptdazavnm"
  resource_group_name = "cptdazavnm"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_network_interface" "res-6" {
  enable_accelerated_networking = true
  location                      = "northeurope"
  name                          = "cptdazavnm1675"
  resource_group_name           = "cptdazavnm"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke1/subnets/subnet1"
  }
  depends_on = [
    # One of azurerm_subnet.res-33,azurerm_subnet_route_table_association.res-34 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_manager" "res-7" {
  location            = "northeurope"
  name                = "cptdazavnm"
  resource_group_name = "cptdazavnm"
  scope_accesses      = ["Connectivity", "SecurityAdmin", "Routing"]
  scope {
    subscription_ids = ["/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e"]
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_network_manager_connectivity_configuration" "res-8" {
  connectivity_topology           = "HubAndSpoke"
  delete_existing_peering_enabled = true
  name                            = "hubandspoke"
  network_manager_id              = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/networkManagers/cptdazavnm"
  applies_to_group {
    group_connectivity = "None"
    network_group_id   = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/networkManagers/cptdazavnm/networkGroups/spokes"
  }
  hub {
    resource_id   = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
    resource_type = "Microsoft.Network/virtualNetworks"
  }
  depends_on = [
    azurerm_network_manager_network_group.res-9,
    azurerm_virtual_network.res-15,
  ]
}
resource "azurerm_network_manager_network_group" "res-9" {
  description        = "all network of type spoke"
  name               = "spokes"
  network_manager_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/networkManagers/cptdazavnm"
  depends_on = [
    azurerm_network_manager.res-7,
  ]
}
resource "azurerm_network_manager_network_group" "res-10" {
  name               = "trusted"
  network_manager_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/networkManagers/cptdazavnm"
  depends_on = [
    azurerm_network_manager.res-7,
  ]
}
resource "azurerm_public_ip" "res-11" {
  allocation_method   = "Static"
  location            = "northeurope"
  name                = "cptdazavnmfw"
  resource_group_name = "cptdazavnm"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_public_ip" "res-12" {
  allocation_method   = "Static"
  location            = "northeurope"
  name                = "cptdazavnmfwm"
  resource_group_name = "cptdazavnm"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_virtual_network" "res-13" {
  address_space       = ["10.11.0.0/16"]
  location            = "northeurope"
  name                = "hub"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "hub"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-14" {
  address_prefixes     = ["10.11.1.0/24"]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "hub"
  depends_on = [
    azurerm_virtual_network.res-13,
  ]
}
resource "azurerm_virtual_network" "res-15" {
  address_space       = ["10.11.0.0/16"]
  location            = "northeurope"
  name                = "hub0"
  resource_group_name = "cptdazavnm"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-16" {
  address_prefixes     = ["10.11.1.0/24"]
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
  ]
}
resource "azurerm_subnet" "res-17" {
  address_prefixes     = ["10.11.0.0/24"]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
  ]
}
resource "azurerm_virtual_network_peering" "res-18" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke0_2436812035"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-28,
  ]
}
resource "azurerm_virtual_network_peering" "res-19" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke1_1948440246"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke1"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-32,
  ]
}
resource "azurerm_virtual_network_peering" "res-20" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke2_3413555613"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke2"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-36,
  ]
}
resource "azurerm_virtual_network_peering" "res-21" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke3_2925183824"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke3"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_virtual_network_peering" "res-22" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke4_0483324879"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke4"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-44,
  ]
}
resource "azurerm_virtual_network_peering" "res-23" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke5_9994953090"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke5"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-48,
  ]
}
resource "azurerm_virtual_network_peering" "res-24" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke6_1460068457"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke6"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-52,
  ]
}
resource "azurerm_virtual_network_peering" "res-25" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke7_0971696668"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke7"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-55,
  ]
}
resource "azurerm_virtual_network_peering" "res-26" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke8_8529837723"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke8"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-59,
  ]
}
resource "azurerm_virtual_network_peering" "res-27" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_hub0_spoke9_8041465934"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke9"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "hub0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-63,
  ]
}
resource "azurerm_virtual_network" "res-28" {
  address_space       = ["10.0.0.0/16"]
  location            = "northeurope"
  name                = "spoke0"
  resource_group_name = "cptdazavnm"
  tags = {
    trusted  = "true"
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-29" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "subnet0"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke0"
  depends_on = [
    azurerm_virtual_network.res-28,
  ]
}
resource "azurerm_subnet_route_table_association" "res-30" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke0/subnets/subnet0"
  depends_on = [
    azurerm_subnet.res-29,
  ]
}
resource "azurerm_virtual_network_peering" "res-31" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke0_hub0_2436812035"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke0"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-28,
  ]
}
resource "azurerm_virtual_network" "res-32" {
  address_space       = ["10.1.0.0/16"]
  location            = "northeurope"
  name                = "spoke1"
  resource_group_name = "cptdazavnm"
  tags = {
    trusted  = "true"
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-33" {
  address_prefixes     = ["10.1.0.0/24"]
  name                 = "subnet1"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke1"
  depends_on = [
    azurerm_virtual_network.res-32,
  ]
}
resource "azurerm_subnet_route_table_association" "res-34" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke1/subnets/subnet1"
  depends_on = [
    azurerm_subnet.res-33,
  ]
}
resource "azurerm_virtual_network_peering" "res-35" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke1_hub0_1948440246"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke1"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-32,
  ]
}
resource "azurerm_virtual_network" "res-36" {
  address_space       = ["10.2.0.0/16"]
  location            = "northeurope"
  name                = "spoke2"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-37" {
  address_prefixes     = ["10.2.0.0/24"]
  name                 = "subnet2"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke2"
  depends_on = [
    azurerm_virtual_network.res-36,
  ]
}
resource "azurerm_subnet_route_table_association" "res-38" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke2/subnets/subnet2"
  depends_on = [
    azurerm_subnet.res-37,
  ]
}
resource "azurerm_virtual_network_peering" "res-39" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke2_hub0_3413555613"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke2"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-36,
  ]
}
resource "azurerm_virtual_network" "res-40" {
  address_space       = ["10.3.0.0/16"]
  location            = "northeurope"
  name                = "spoke3"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-41" {
  address_prefixes     = ["10.3.0.0/24"]
  name                 = "subnet3"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke3"
  depends_on = [
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_subnet_route_table_association" "res-42" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke3/subnets/subnet3"
  depends_on = [
    azurerm_subnet.res-41,
  ]
}
resource "azurerm_virtual_network_peering" "res-43" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke3_hub0_2925183824"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke3"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_virtual_network" "res-44" {
  address_space       = ["10.4.0.0/16"]
  location            = "northeurope"
  name                = "spoke4"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-45" {
  address_prefixes     = ["10.4.0.0/24"]
  name                 = "subnet4"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke4"
  depends_on = [
    azurerm_virtual_network.res-44,
  ]
}
resource "azurerm_subnet_route_table_association" "res-46" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke4/subnets/subnet4"
  depends_on = [
    azurerm_subnet.res-45,
  ]
}
resource "azurerm_virtual_network_peering" "res-47" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke4_hub0_0483324879"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke4"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-44,
  ]
}
resource "azurerm_virtual_network" "res-48" {
  address_space       = ["10.5.0.0/16"]
  location            = "northeurope"
  name                = "spoke5"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-49" {
  address_prefixes     = ["10.5.0.0/24"]
  name                 = "subnet5"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke5"
  depends_on = [
    azurerm_virtual_network.res-48,
  ]
}
resource "azurerm_subnet_route_table_association" "res-50" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke5/subnets/subnet5"
  depends_on = [
    azurerm_subnet.res-49,
  ]
}
resource "azurerm_virtual_network_peering" "res-51" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke5_hub0_9994953090"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke5"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-48,
  ]
}
resource "azurerm_virtual_network" "res-52" {
  address_space       = ["10.6.0.0/16"]
  location            = "northeurope"
  name                = "spoke6"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_virtual_network_peering" "res-54" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke6_hub0_1460068457"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke6"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-52,
  ]
}
resource "azurerm_virtual_network" "res-55" {
  address_space       = ["10.7.0.0/16"]
  location            = "northeurope"
  name                = "spoke7"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-56" {
  address_prefixes     = ["10.7.0.0/24"]
  name                 = "subnet7"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke7"
  depends_on = [
    azurerm_virtual_network.res-55,
  ]
}
resource "azurerm_subnet_route_table_association" "res-57" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke7/subnets/subnet7"
  depends_on = [
    azurerm_subnet.res-56,
  ]
}
resource "azurerm_virtual_network_peering" "res-58" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke7_hub0_0971696668"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke7"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-55,
  ]
}
resource "azurerm_virtual_network" "res-59" {
  address_space       = ["10.8.0.0/16"]
  location            = "northeurope"
  name                = "spoke8"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-60" {
  address_prefixes     = ["10.8.0.0/24"]
  name                 = "subnet8"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke8"
  depends_on = [
    azurerm_virtual_network.res-59,
  ]
}
resource "azurerm_subnet_route_table_association" "res-61" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke8/subnets/subnet8"
  depends_on = [
    azurerm_subnet.res-60,
  ]
}
resource "azurerm_virtual_network_peering" "res-62" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke8_hub0_8529837723"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke8"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-59,
  ]
}
resource "azurerm_virtual_network" "res-63" {
  address_space       = ["10.9.0.0/16"]
  location            = "northeurope"
  name                = "spoke9"
  resource_group_name = "cptdazavnm"
  tags = {
    vnettype = "spoke"
  }
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-64" {
  address_prefixes     = ["10.9.0.0/24"]
  name                 = "subnet9"
  resource_group_name  = "cptdazavnm"
  virtual_network_name = "spoke9"
  depends_on = [
    azurerm_virtual_network.res-63,
  ]
}
resource "azurerm_subnet_route_table_association" "res-65" {
  route_table_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/AVNM_Managed_ResourceGroup_4896a771-b1ab-4411-bd94-3c8467f1991e/providers/Microsoft.Network/routeTables/AVNM_Managed_312496641AD74FC994A9D15A92911F72"
  subnet_id      = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/spoke9/subnets/subnet9"
  depends_on = [
    azurerm_subnet.res-64,
  ]
}
resource "azurerm_virtual_network_peering" "res-66" {
  allow_forwarded_traffic   = true
  name                      = "ANM_22740FFA83EB4B03043CC7E_spoke9_hub0_8041465934"
  remote_virtual_network_id = "/subscriptions/4896a771-b1ab-4411-bd94-3c8467f1991e/resourceGroups/cptdazavnm/providers/Microsoft.Network/virtualNetworks/hub0"
  resource_group_name       = "cptdazavnm"
  virtual_network_name      = "spoke9"
  depends_on = [
    azurerm_virtual_network.res-15,
    azurerm_virtual_network.res-63,
  ]
}
