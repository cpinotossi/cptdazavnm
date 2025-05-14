resource "azurerm_firewall" "firewall" {
  name                = var.prefix
  location            = azurerm_resource_group.rg_plattform_lz_1.location
  resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id
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
  provider = azurerm.plattform_lz_1
}

resource "azurerm_firewall_policy" "firewall_policy" {
  name                = var.prefix
  location            = azurerm_resource_group.rg_plattform_lz_1.location
  resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
  sku                 = "Basic"
  provider            = azurerm.plattform_lz_1
}

resource "azurerm_firewall_policy_rule_collection_group" "spoke_to_spoke" {
  name               = var.prefix
  priority           = 100
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id

  network_rule_collection {
    name     = "spoke-to-spoke-rules"
    priority = 100
    action   = "Allow"
    rule {
      name = "allow-spoke-to-spoke"
      source_addresses = [
        "${var.cidrs["spoke1"]}",
        "${var.cidrs["spoke2"]}",
        "${var.cidrs["spoke3"]}"
      ]

      destination_addresses = [
        "${var.cidrs["spoke1"]}",
        "${var.cidrs["spoke2"]}",
        "${var.cidrs["spoke3"]}"
      ]

      destination_ports = ["*"]
      protocols         = ["TCP", "UDP", "ICMP"]
    }
    rule {
      name = "allow-ifconfig-io-http"
      source_addresses = [
        "${var.cidrs["spoke1"]}",
        "${var.cidrs["spoke2"]}",
        "${var.cidrs["spoke3"]}"
      ]

      destination_addresses = ["104.21.92.106"]

      destination_ports = ["80"]
      protocols         = ["TCP"]
    }
  }
  provider = azurerm.plattform_lz_1
}

resource "azurerm_firewall_policy_rule_collection_group" "allow_ifconfig_io" {
  name               = "${var.prefix}-allow-ifconfig-io"
  priority           = 200
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id

  application_rule_collection {
    name     = "allow-ifconfig-io"
    priority = 200
    action   = "Allow"

    rule {
      name = "allow-ifconfig-io"
      source_addresses = [
        "0.0.0.0/0" # Adjust this to restrict the source if needed
      ]
      protocols {
        type = "Https"
        port = 443
      }
      destination_fqdns = ["ifconfig.io"]
    }
  }
  provider = azurerm.plattform_lz_1
}

resource "azurerm_public_ip" "public_ip_fw" {
  name                = "${var.prefix}fw"
  location            = azurerm_resource_group.rg_plattform_lz_1.location
  resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
  allocation_method   = "Static"

  sku      = "Standard"
  provider = azurerm.plattform_lz_1
}

resource "azurerm_public_ip" "public_ip_fw_mgmt" {
  name                = "${var.prefix}fwm"
  location            = azurerm_resource_group.rg_plattform_lz_1.location
  resource_group_name = azurerm_resource_group.rg_plattform_lz_1.name
  allocation_method   = "Static"

  sku      = "Standard"
  provider = azurerm.plattform_lz_1
}

resource "azurerm_monitor_diagnostic_setting" "firewall_logs" {
  name                       = "${var.prefix}-firewall-logs"
  target_resource_id         = azurerm_firewall.firewall.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
  # https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/microsoft-network-azurefirewalls-logs
  enabled_log {
    category = "AZFWApplicationRule"
  }

  enabled_log {
    category = "AZFWApplicationRuleAggregation"
  }

  enabled_log {
    category = "AZFWDnsQuery"
  }

  enabled_log {
    category = "AZFWFatFlow"
  }
  enabled_log {
    category = "AZFWFlowTrace"
  }
  enabled_log {
    category = "AZFWFqdnResolveFailure"
  }
  enabled_log {
    category = "AZFWIdpsSignature"
  }
  enabled_log {
    category = "AZFWNatRule"
  }
  enabled_log {
    category = "AZFWNatRuleAggregation"
  }
  enabled_log {
    category = "AZFWNetworkRule"
  }
  enabled_log {
    category = "AZFWNetworkRuleAggregation"
  }
  enabled_log {
    category = "AZFWThreatIntel"
  }
  enabled_log {
    category = "AzureFirewallApplicationRule"
  }
  enabled_log {
    category = "AzureFirewallDnsProxy"
  }
  enabled_log {
    category = "AzureFirewallNetworkRule"
  }
  provider = azurerm.plattform_lz_1
}




