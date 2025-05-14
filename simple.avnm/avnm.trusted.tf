####################################################
# network group trusted
####################################################

resource "azurerm_network_manager_network_group" "network_manager_group_trusted" {
  name               = "trusted"
  description        = "all network which are trusted"
  network_manager_id = azurerm_network_manager.network_manager_mg_root.id
  provider           = azurerm.plattform_lz_1
  depends_on = [
    azurerm_network_manager.network_manager_mg_root,
  ]
}
######################################################
# policy trusted
######################################################

resource "azurerm_policy_definition" "network_group_policy_connectivity_trusted" {
  name                = "${var.prefix}trusted"
  management_group_id = var.management_group_root_id
  policy_type         = "Custom"
  mode                = "Microsoft.Network.Data"
  display_name        = "Azure Virtual Network Manager Policy Definition for Network Group trusted"

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
          "equals": "trusted"
          }
        ]
      },
      "then": {
        "effect": "addToNetworkGroup",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.network_manager_group_trusted.id}"
        }
      }
        }
  POLICY_RULE
  provider    = azurerm.root_1
}

resource "azurerm_management_group_policy_assignment" "azure_policy_assignment_trusted" {
  name                 = "${var.prefix}trusted"
  policy_definition_id = azurerm_policy_definition.network_group_policy_connectivity_trusted.id
  management_group_id  = var.management_group_root_id
  provider             = azurerm.plattform_lz_1
}
