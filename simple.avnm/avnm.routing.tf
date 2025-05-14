####################################################
# configuration routing
####################################################

locals {
  routing_config_hubspoke_rule_col_rules = [
    {
      name             = "firewall"
      type             = "AddressPrefix"
      address_prefix   = "0.0.0.0/0"
      next_hop_type    = "VirtualAppliance"
      next_hop_address = "10.0.1.4"
    },
  ]
}

resource "azapi_resource" "routing_config_hubspoke" {
  type      = "Microsoft.Network/networkManagers/routingConfigurations@2024-05-01"
  name      = "${var.prefix}routing"
  parent_id = azurerm_network_manager.network_manager_mg_root.id

  body = {
    properties = {
      description = "Routing configuration for hub-spoke topology"
    }
  }
  schema_validation_enabled = false
  response_export_values    = ["id"]
  provider                  = azapi.plattform_lz_1
}

resource "azapi_resource" "routing_config_hubspoke_rule_collection" {
  type      = "Microsoft.Network/networkManagers/routingConfigurations/ruleCollections@2024-05-01"
  name      = "${var.prefix}routinghubandspoke"
  parent_id = azapi_resource.routing_config_hubspoke.id

  body = {
    properties = {
      description       = "rule collection for hub-spoke topology"
      # localRouteSetting = "DirectRoutingWithinVNet"
      appliesTo = [
        {
          networkGroupId = azurerm_network_manager_network_group.network_manager_group_spokes.id
        }
      ]
      disableBgpRoutePropagation = "True"
    }
  }
  schema_validation_enabled = false
  provider                  = azapi.plattform_lz_1
}

resource "azapi_resource" "routing_config_hubspoke_rule_collection_rules" {
  for_each  = { for r in local.routing_config_hubspoke_rule_col_rules : r.name => r }
  type      = "Microsoft.Network/networkManagers/routingConfigurations/ruleCollections/rules@2024-05-01"
  name      = each.value.name
  parent_id = azapi_resource.routing_config_hubspoke_rule_collection.id

  body = {
    properties = {
      destination : {
        type               = each.value.type
        destinationAddress = each.value.address_prefix
      },
      nextHop : {
        nextHopType    = each.value.next_hop_type
        nextHopAddress = each.value.next_hop_address
      }
    }
  }
  schema_validation_enabled = false
  response_export_values    = ["*"]
  provider                  = azapi.plattform_lz_1
}