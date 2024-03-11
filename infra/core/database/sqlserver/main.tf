resource "azurerm_sql_server" "sql_server" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location = var.location
  version = 12.0
  administrator_login = var.sql_admin
  administrator_login_password = var.sql_admin_password
}
resource "azurerm_sql_firewall_rule" "firewall_rule" {
// Allow all clients
// Note: range [0.0.0.0-0.0.0.0] means "allow all Azure-hosted clients only".
// This is not sufficient, because we also want to allow direct access from developer machine, for debugging purposes.      
  name                = "Azure Services"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  start_ip_address    = "0.0.0.1"
  end_ip_address      = "255.255.255.254"
}
resource "azurerm_sql_database" "db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name
}

resource "azurerm_resource_deployment_script_azure_cli" "sql_deployment_script" {
  name                = "${var.name}-deployment-script"
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "2.37.0"
  retention_interval  = "PT1H" // Retain the script resource for 1 hour after it ends running
  command_line        = "'foo' 'bar'"
  cleanup_preference  = "OnSuccess"
  force_update_tag    = "1"
  timeout             = "PT5M"// Five minutes
  environment_variable {
      name = "APPUSERNAME"
      value = var.app_user
  }
  environment_variable {
        name= "APPUSERPASSWORD"
        secure_value = var.sql_user_password
      }
  environment_variable {
        name= "DBNAME"
        value= var.database_name
      }
  environment_variable {
        name= "DBSERVER"
        value= azurerm_sql_server.sql_server.fully_qualified_domain_name
      }
  environment_variable {
        name= "SQLCMDPASSWORD"
        secure_value= var.sql_admin_password
      }
  environment_variable {
        name= "SQLADMIN"
        value= var.sql_admin
      }
  script_content = <<EOF
            wget https://github.com/microsoft/go-sqlcmd/releases/download/v0.8.1/sqlcmd-v0.8.1-linux-x64.tar.bz2
            tar x -f sqlcmd-v0.8.1-linux-x64.tar.bz2 -C .

            cat <<SCRIPT_END > ./initDb.sql
            drop user if exists ${APPUSERNAME}
            go
            create user ${APPUSERNAME} with password = '${APPUSERPASSWORD}'
            go
            alter role db_owner add member ${APPUSERNAME}
            go
            SCRIPT_END

            ./sqlcmd -S ${DBSERVER} -d ${DBNAME} -U ${SQLADMIN} -i ./initDb.sql
  EOF
}
data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_secret" "sqlAdminPasswordSecret" {
  name         = "sqlAdminPassword"
  value        = var.sql_admin_password
  key_vault_id = azurerm_key_vault.key_vault.id
}
resource "azurerm_key_vault_secret" "appUserPasswordSecret" {
  name         = "appUserPassword"
  value        = var.sql_user_password
  key_vault_id = azurerm_key_vault.key_vault.id
}
resource "azurerm_key_vault_secret" "sqlAzureConnectionStringSercret" {
  name         = var.connection_string_key
  //value        = "Server=${sqlServer.properties.fullyQualifiedDomainName}; Database=${sqlServer::database.name}; User=${var.app_user}; Password=${var.sql_user_password}"
  value = "Server=tcp:${azurerm_sql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.sql_server.administrator_login};Password=${azurerm_sql_server.sql_server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.key_vault.id
}
