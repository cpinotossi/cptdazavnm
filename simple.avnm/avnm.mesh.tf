# ####################################################
# # AVNM
# ####################################################

# resource "azurerm_network_manager" "network_manager_mg_landingzones" {
#   name                = "${var.prefix}mglandingzones"
#   location            = azurerm_resource_group.rg_plattform_lz_1.location
#   resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
#   scope_accesses      = ["Connectivity", "SecurityAdmin", "Routing"]
#   scope {
#     management_group_ids = [var.management_group_landingzones_id]
#   }
#   provider = azurerm.plattform_lz_1
#   depends_on = [
#     azurerm_resource_group.rg,
#   ]
# }

# ####################################################
# # network group
# ####################################################

# resource "azurerm_network_manager_network_group" "network_manager_group_meshed" {
#   name               = "meshed"
#   description        = "all network of type spoke"
#   network_manager_id = azurerm_network_manager.network_manager_mg_landingzones.id
#   provider           = azurerm.plattform_lz_1
#   depends_on = [
#     azurerm_network_manager.network_manager_mg_landingzones,
#   ]
# }


# ######################################################
# # configuration connectivity Meshed vnet_type
# ######################################################

# resource "azurerm_policy_definition" "network_group_policy_connectivity_meshed" {
#   name                = "${var.prefix}meshed"
#   management_group_id = var.management_group_landingzones_id
#   policy_type         = "Custom"
#   mode                = "Microsoft.Network.Data"
#   display_name        = "Azure Virtual Network Manager Policy Definition for Network Group Meshed"

#   metadata = <<METADATA
#     {
#       "category": "Azure Virtual Network Manager"
#     }
#   METADATA

#   policy_rule = <<POLICY_RULE
#     {
#       "if": {
#         "allOf": [
#           {
#           "field": "type",
#           "equals": "Microsoft.Network/virtualNetworks"
#           },
#           {
#           "field": "tags['vnet_type']",
#           "equals": "spoke"
#           }
#         ]
#       },
#       "then": {
#         "effect": "addToNetworkGroup",
#         "details": {
#           "networkGroupId": "${azurerm_network_manager_network_group.network_manager_group_meshed.id}"
#         }
#       }
#         }
#   POLICY_RULE
#   provider    = azurerm.root_1
# }

# resource "azurerm_management_group_policy_assignment" "azure_policy_assignment_meshed" {
#   name                 = "${var.prefix}meshed"
#   policy_definition_id = azurerm_policy_definition.network_group_policy_connectivity_meshed.id
#   management_group_id  = var.management_group_landingzones_id
#   provider             = azurerm.plattform_lz_1
# }

# resource "azurerm_network_manager_connectivity_configuration" "network_manager_connectivity_configuration_meshed" {
#   connectivity_topology           = "Mesh"
#   delete_existing_peering_enabled = false
#   name                            = "${var.prefix}connectivitymeshed"
#   global_mesh_enabled             = true
#   network_manager_id              = azurerm_network_manager.network_manager_mg_landingzones.id
#   applies_to_group {
#     group_connectivity = "None" # not DirectlyConnected
#     network_group_id   = azurerm_network_manager_network_group.network_manager_group_meshed.id
#   }
#   provider = azurerm.plattform_lz_1
#   depends_on = [
#     azurerm_network_manager_network_group.network_manager_group_meshed,
#   ]
# }

# resource "azurerm_network_manager_deployment" "commit_meshed_deployment_eu" {
#   count              = length(var.eu_regions)                                                                                           # Creates multiple deployments, one for each region in the 'eu_regions' variable.
#   network_manager_id = azurerm_network_manager.network_manager_mg_landingzones.id                                                              # References the ID of the Azure Network Manager.
#   location           = var.eu_regions[count.index]                                                                                      # Dynamically sets the location for each deployment based on the current region in 'eu_regions'.
#   scope_access       = "Connectivity"                                                                                                   # Specifies the scope of the deployment as "Connectivity".
#   configuration_ids  = [azurerm_network_manager_connectivity_configuration.network_manager_connectivity_configuration_meshed.id] # References the ID of the connectivity configuration to be deployed.
#   provider           = azurerm.plattform_lz_1
# }

