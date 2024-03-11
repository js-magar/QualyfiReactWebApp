resource "azurerm_cognitive_account" "cognitive_account" {
  # Required variables here
  kind = var.kind
  sku_name = var.sku_name
  location = var.location
  name = var.name
  resource_group_name = var.resource_group_name
  # Optional Variables
  custom_subdomain_name = var.customSubDomainName
  public_network_access_enabled = var.publicNetworkAccess
  network_acls { 
    default_action = var.networkAcls.defaultAction
  }
}

resource "azurerm_cognitive_deployment" "cognitive_deployment" {
  cognitive_account_id = azurerm_cognitive_account.example.id
  count = length(var.deployments)
  name = var.deployments[count.index].name
  model {
    format  = var.deployments[count.index].model.format
    name    = var.deployments[count.index].model.name
    version = var.deployments[count.index].model.version
  }
  rai_policy_name =  can(var.deployments[count.index], "raiPolicyName") ? var.deployments[count.index].raiPolicyName : null
  scale {
    type = "Standard"
  }
}