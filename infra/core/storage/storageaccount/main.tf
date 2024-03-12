//Creates an Azure storage account.
terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}
resource "azurerm_storage_account" "storage" {
  name                = var.name
  resource_group_name = var.resource_group_name

  location                 = var.location
  account_tier             = var.sku.account_tier
  account_replication_type = var.sku.account_replication_type

  network_rules {
    default_action             = var.network_acls.default_action
    bypass = var.network_acls.bypass
  }
  public_network_access_enabled = var.public_network_access
  min_tls_version = var.minimum_tls_version
  access_tier = var.access_tier
  cross_tenant_replication_enabled= var.allow_cross_tenant_replication
  shared_access_key_enabled=var.allow_shared_key_access
  enable_https_traffic_only = var.supports_https_traffic_only
  default_to_oauth_authentication = var.default_to_oauth_authentication
  //dnsEndpointType: dnsEndpointType
  //allowBlobPublicAccess: allowBlobPublicAccess
  /*
  dynamic "blob_services" {
    for_each = var.containers != [] ? [1] : []

    content {
      name = "default"
      properties {
        delete_retention_policy {
          enabled = var.deleteRetentionPolicy.enabled
          days    = var.deleteRetentionPolicy.days
        }
      }
      
      dynamic "containers" {
        for_each = var.containers

        content {
          name = containers.value.name
          properties {
            public_access = contains(containers.value, "publicAccess") ? containers.value.publicAccess : "None"
          }
        }
      }
    }
  }
  */
}
/*
resource "azapi_resource" "blob_services" {
  type = "Microsoft.Storage/storageAccounts/blobServices@2023-01-01"
  name = "default"
  parent_id = azurerm_storage_account.storage.id
  body = jsonencode({
    properties = {
      deleteRetentionPolicy = var.delete_retention_policy
    }
  })
}

resource "azapi_resource" "containers" {
  for_each = var.containers
  type = "Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01"
  name = var.containers.value.name
  parent_id = azapi_resource.blob_services.id
  body = jsonencode({
    properties = {
      publicAccess =  contains(var.containers.value, "publicAccess") ? var.containers.value.publicAccess : "None"
    }
  })
}
*/