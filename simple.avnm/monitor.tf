resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                       = var.prefix
  location                   = azurerm_resource_group.rg_plattform_lz_1.location
  resource_group_name        = azurerm_resource_group.rg_plattform_lz_1.name
  sku                        = "PerGB2018"
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  provider                   = azurerm.plattform_lz_1
}

data "azurerm_network_watcher" "network_watcher" {
  name                = "NetworkWatcher_${azurerm_resource_group.rg_plattform_lz_1.location}"
  resource_group_name = "NetworkWatcherRG"
  provider            = azurerm.plattform_lz_1
}

resource "azurerm_network_connection_monitor" "connection_monitor" {
  name               = var.prefix
  network_watcher_id = data.azurerm_network_watcher.network_watcher.id
  location           = var.location

  endpoint {
    name                 = "spoke1"
    target_resource_id   = module.spoke1_vm.vm.id
    target_resource_type = "AzureVM"
  }
  endpoint {
    name                 = "spoke2"
    target_resource_id   = module.spoke2_vm.vm.id
    target_resource_type = "AzureVM"
  }
  endpoint {
    name                 = "spoke3"
    target_resource_id   = module.spoke3_vm.vm.id
    target_resource_type = "AzureVM"
  }
  endpoint {
    name                 = "hub1"
    target_resource_id   = module.hub1_vm.vm.id
    target_resource_type = "AzureVM"
  }
  endpoint {
    name                 = "ifconfigio"
    address              = "ifconfig.io"
    target_resource_type = "ExternalAddress"
  }
  test_configuration {
    name                      = "icmp"
    protocol                  = "Icmp"
    test_frequency_in_seconds = 30
    icmp_configuration {
      trace_route_enabled = true
    }
  }
  test_configuration {
    name                      = "http"
    protocol                  = "Http"
    test_frequency_in_seconds = 30
    preferred_ip_version      = "IPv4"
    http_configuration {
      port   = 443
      method = "Get"
      # path               = "/"
      prefer_https             = true
      valid_status_code_ranges = ["200"]
    }
  }
  test_group {
    name                     = "spoke1-to-hub1"
    destination_endpoints    = ["hub1"]
    source_endpoints         = ["spoke1"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke1-to-spoke2"
    destination_endpoints    = ["spoke2"]
    source_endpoints         = ["spoke1"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke1-to-spoke3"
    destination_endpoints    = ["spoke3"]
    source_endpoints         = ["spoke1"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke2-to-hub1"
    destination_endpoints    = ["hub1"]
    source_endpoints         = ["spoke2"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke2-to-spoke1"
    destination_endpoints    = ["spoke1"]
    source_endpoints         = ["spoke2"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke2-to-spoke3"
    destination_endpoints    = ["spoke3"]
    source_endpoints         = ["spoke2"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke3-to-hub1"
    destination_endpoints    = ["hub1"]
    source_endpoints         = ["spoke3"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke3-to-spoke1"
    destination_endpoints    = ["spoke1"]
    source_endpoints         = ["spoke3"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke3-to-spoke2"
    destination_endpoints    = ["spoke2"]
    source_endpoints         = ["spoke3"]
    test_configuration_names = ["icmp"]
  }
  test_group {
    name                     = "spoke1-to-ifconfigio"
    destination_endpoints    = ["ifconfigio"]
    source_endpoints         = ["spoke1"]
    test_configuration_names = ["http"]
  }
  test_group {
    name                     = "spoke2-to-ifconfigio"
    destination_endpoints    = ["ifconfigio"]
    source_endpoints         = ["spoke2"]
    test_configuration_names = ["http"]
  }
  test_group {
    name                     = "spoke3-to-ifconfigio"
    destination_endpoints    = ["ifconfigio"]
    source_endpoints         = ["spoke3"]
    test_configuration_names = ["http"]
  }
  test_group {
    name                     = "hub1-to-ifconfigio"
    destination_endpoints    = ["ifconfigio"]
    source_endpoints         = ["hub1"]
    test_configuration_names = ["http"]
  }
  output_workspace_resource_ids = [azurerm_log_analytics_workspace.log_analytics.id]
  provider                      = azurerm.plattform_lz_1
  depends_on = [
    module.hub1_vm, module.spoke1_vm, module.spoke2_vm, module.spoke3_vm
  ]
}