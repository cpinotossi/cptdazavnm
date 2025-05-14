

resource "azurerm_storage_account" "storage" {
  name                     = "${var.prefix}azvnm"
  location                 = azurerm_resource_group.rg_plattform_lz_1.location
  resource_group_name      = azurerm_resource_group.rg_plattform_lz_1.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  provider                 = azurerm.plattform_lz_1
}

resource "azurerm_storage_container" "storage_container_flowlogs" {
  name                  = "flowlogs"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
  provider              = azurerm.plattform_lz_1
}

resource "azurerm_role_assignment" "blob_storage_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  provider             = azurerm.plattform_lz_1
}