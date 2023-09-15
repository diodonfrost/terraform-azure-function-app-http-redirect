resource "random_pet" "suffix" {}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = "test-${random_pet.suffix.id}"
  location = "East US"
}


module "azure-function-http-redirect" {
  source = "../../"

  function_app_name    = "fpn-${random_pet.suffix.id}"
  service_plan_name    = "spn-${random_pet.suffix.id}"
  storage_account_name = "san${random_id.suffix.hex}"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  redirect_mappings = {
    "foo.example.com" : "https://foo.com",
    "bar.example.com" : "https://bar.com",
  }
}
