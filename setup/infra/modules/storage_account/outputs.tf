output "tfstate_blob" {
  description = "Generated Tfstate storage location"
  value       = azurerm_storage_account.tfstate.location
}