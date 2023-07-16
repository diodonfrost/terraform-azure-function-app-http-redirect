data "azurerm_subscription" "current" {}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku_name

  tags = var.tags
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/functions/"
  output_path = "${path.module}/functions.zip"
}

resource "azurerm_linux_function_app" "this" {
  name                = "${var.function_app_name_prefix}-${substr(data.archive_file.this.output_sha512, 0, 8)}" # trigger redeploy on zip change
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name        = azurerm_storage_account.this.name
  storage_account_access_key  = azurerm_storage_account.this.primary_access_key
  service_plan_id             = azurerm_service_plan.this.id
  functions_extension_version = "~4"
  zip_deploy_file             = data.archive_file.this.output_path

  site_config {
    application_insights_connection_string = azurerm_application_insights.this.connection_string
    application_insights_key               = azurerm_application_insights.this.instrumentation_key
    application_stack {
      python_version = "3.10"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    ENABLE_ORYX_BUILD              = true
    AzureWebJobsDisableHomepage    = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
    redirect_mappings              = jsonencode(var.redirect_mappings)
    http_redirect_code             = var.http_redirect_code
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = "${var.function_app_name_prefix}-${substr(data.archive_file.this.output_sha512, 0, 8)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "other"

  tags = var.tags
}
