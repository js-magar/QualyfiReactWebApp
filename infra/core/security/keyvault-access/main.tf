//Assigns an Azure Key Vault access policy.
data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  resource_group_name         = var.resource_group_name
}
resource "azurerm_key_vault_access_policy" "key_vault_access_policy_1" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.principal_id
  secret_permissions = var.permissions.secrets
}
/*
resource "azurerm_key_vault_access_policy" "key_vault_access_policy_2" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  secret_permissions = var.permissions.secrets
}
*/