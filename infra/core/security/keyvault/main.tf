//Creates an Azure Key Vault.
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "key_vault" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"

  dynamic "access_policy" {
    for_each = var.principal_id != "" ? [1] : []
    content {
      tenant_id         = data.azurerm_client_config.current.tenant_id
      object_id         = var.principal_id
      secret_permissions = ["Get", "List"]
    }
  }
}
