resource "random_string" "resource_code" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "k3stfstate${random_string.resource_code.result}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "multinode-k3s"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}
