

data "azurerm_subscription" "subscription" {
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.prefix
}

resource "azurerm_network_manager" "network_manager" {
  location            = azurerm_resource_group.rg.location
  name                = var.prefix
  resource_group_name = var.prefix
  scope_accesses      = ["Connectivity", "SecurityAdmin", "Routing"]
  scope {
    subscription_ids = ["/subscriptions/${var.subscription_id}"]
  }
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_network_manager_network_group" "network_manager_group" {
  description        = "all network of type spoke"
  name               = "spokes"
  network_manager_id = azurerm_network_manager.network_manager.id
  depends_on = [
    azurerm_network_manager.network_manager,
  ]
}

resource "azurerm_policy_definition" "network_group_policy" {
  name         = "hub_and_spoke"
  policy_type  = "Custom"
  mode         = "Microsoft.Network.Data"
  display_name = "Policy Definition for Network Group Hub and Spoke"

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
          "networkGroupId": "${azurerm_network_manager_network_group.network_manager_group.id}"
        }
      }
        }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "azure_policy_assignment" {
  name                 = "hub-and-spoke-policy-assignment"
  policy_definition_id = azurerm_policy_definition.network_group_policy.id
  subscription_id      = data.azurerm_subscription.subscription.id
}

resource "azurerm_network_manager_network_group" "network_manager_group_trusted" {
  name               = "trusted"
  network_manager_id = azurerm_network_manager.network_manager.id
  depends_on = [
    azurerm_network_manager.network_manager,
  ]
}

resource "azurerm_network_manager_connectivity_configuration" "network_manager_connectivity_configuration_hub_and_spoke" {
  connectivity_topology           = "HubAndSpoke"
  delete_existing_peering_enabled = true
  name                            = "hubandspoke"
  network_manager_id              = azurerm_network_manager.network_manager.id
  applies_to_group {
    group_connectivity = "None"
    network_group_id   = azurerm_network_manager_network_group.network_manager_group.id
  }
  hub {
    resource_id   = azurerm_virtual_network.hub_vnet.id
    resource_type = "Microsoft.Network/virtualNetworks"
  }
  depends_on = [
    azurerm_network_manager_network_group.network_manager_group,
    azurerm_virtual_network.hub_vnet,
  ]
}

# Commit deployment
resource "azurerm_network_manager_deployment" "commit_hub_and_spoke_deployment" {
  network_manager_id = azurerm_network_manager.network_manager.id
  location           = azurerm_resource_group.rg.location
  scope_access       = "Connectivity"
  configuration_ids  = [azurerm_network_manager_connectivity_configuration.network_manager_connectivity_configuration_hub_and_spoke.id]
}