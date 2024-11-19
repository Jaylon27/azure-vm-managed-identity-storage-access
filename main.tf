# Resource Group to contain all resources
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources"
  location = var.location
}

# Storage Account for storing blobs and other data
resource "azurerm_storage_account" "example" {
  name                     = "${var.prefix}storage"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "${var.prefix}storagecontainer"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}



