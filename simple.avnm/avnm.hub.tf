####################################################
# AVNM
####################################################

resource "azurerm_network_manager" "network_manager_mg_root" {
  name                = "${var.prefix}mgroot"
  location            = azurerm_resource_group.rg_plattform_lz_1.location
  resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
  scope_accesses      = ["Connectivity", "SecurityAdmin", "Routing"]
  scope {
    management_group_ids = [var.management_group_root_id]
  }
  provider = azurerm.plattform_lz_1
  depends_on = [
    azurerm_resource_group.rg_plattform_lz_1,
  ]
}

####################################################
# network group spoke
####################################################

resource "azurerm_network_manager_network_group" "network_manager_group_spokes" {
  name               = "spokes"
  description        = "all network of type spoke"
  network_manager_id = azurerm_network_manager.network_manager_mg_root.id
  provider           = azurerm.plattform_lz_1
  depends_on = [
    azurerm_network_manager.network_manager_mg_root,
  ]
}

######################################################
# configuration connectivity Hub and Spoke vnet_type
######################################################

resource "azurerm_policy_definition" "network_group_policy_connectivity_hub_and_spoke" {
  name                = "${var.prefix}hubandspoke"
  management_group_id = var.management_group_root_id
  policy_type         = "Custom"
  mode                = "Microsoft.Network.Data"
  display_name        = "Azure Virtual Network Manager Policy Definition for Network Group Hub and Spoke"

  metadata = <<METADATA
    {
      "category": "Azure Virtual Network Manager"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
          "field": "type",
          "equals": "Microsoft.Network/virtualNetworks"
          },
          {
          "field": "tags['vnet_type']",
          "equals": "spoke"
          }
        ]
      },
      "then": {
        "effect": "addToNetworkGroup",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.network_manager_group_spokes.id}"
        }
      }
        }
  POLICY_RULE
  provider    = azurerm.root_1
}

resource "azurerm_management_group_policy_assignment" "azure_policy_assignment_hub_and_spoke" {
  name                 = "${var.prefix}hubandspoke"
  policy_definition_id = azurerm_policy_definition.network_group_policy_connectivity_hub_and_spoke.id
  management_group_id  = var.management_group_root_id
  provider             = azurerm.plattform_lz_1
}

resource "azurerm_network_manager_connectivity_configuration" "network_manager_connectivity_configuration_hub_and_spoke" {
  connectivity_topology           = "HubAndSpoke"
  delete_existing_peering_enabled = false
  name                            = "${var.prefix}connectivityhubandspoke"
  global_mesh_enabled             = false
  network_manager_id              = azurerm_network_manager.network_manager_mg_root.id
  # applies_to_group {
  #   group_connectivity = "None"
  #   network_group_id   = azurerm_network_manager_network_group.network_manager_group_spokes.id
  # }
  applies_to_group {
    group_connectivity = "None" # not DirectlyConnected
    network_group_id   = azurerm_network_manager_network_group.network_manager_group_trusted.id
  }
  hub {
    resource_id   = azurerm_virtual_network.hub1_vnet.id
    resource_type = "Microsoft.Network/virtualNetworks"
  }
  provider = azurerm.plattform_lz_1
  depends_on = [
    azurerm_network_manager_network_group.network_manager_group_spokes,
  ]
}

resource "azurerm_network_manager_deployment" "commit_hub_and_spoke_deployment_eu" {
  count              = length(var.eu_regions)
  network_manager_id = azurerm_network_manager.network_manager_mg_root.id
  location           = var.eu_regions[count.index]
  scope_access       = "Connectivity"
  configuration_ids  = [azurerm_network_manager_connectivity_configuration.network_manager_connectivity_configuration_hub_and_spoke.id]
  provider           = azurerm.plattform_lz_1
}

