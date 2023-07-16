# terraform-azure-function-http-redirect

[![CI](https://github.com/diodonfrost/terraform-azure-function-http-redirect/workflows/CI/badge.svg)](https://github.com/diodonfrost/terraform-azure-function-http-redirect)

Terraform module which create an Azure function to redirect specific domains.

## Usage
```hcl
module "azure-function-http-redirect" {
  source = "diodonfrost/function-http-redirect/azure"

  function_app_name_prefix      = "my-function-app-name"
  service_plan_name             = "my-service-plan-name"
  storage_account_name          = "my-storage-account-name"
  resource_group_name           = "my-resource-group-name"
  location                      = "westeurope"
  redirect_mappings             = {
    "foo.example.com": "https://foo.com",
    "bar.example.com": "https://bar.com",
  }
}
```

## Examples

*   [main](https://github.com/diodonfrost/terraform-azure-function-http-redirect/tree/master/examples/main) - Creat Azure function to redirect specific domains.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_function_app_name_prefix"></a> [function\_app\_name\_prefix](#input\_function\_app\_name\_prefix) | The prefix of the Azure Function App name | `string` | n/a | yes |
| <a name="input_http_redirect_code"></a> [http\_redirect\_code](#input\_http\_redirect\_code) | Which HTTP redirect code to use | `string` | `"301"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the Azure resources | `string` | n/a | yes |
| <a name="input_redirect_mappings"></a> [redirect\_mappings](#input\_redirect\_mappings) | A key/value map of source domain name -> target url redirects. | `map(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group where the Linux Function App should exist | `string` | n/a | yes |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | The name of the Azure service plan | `string` | n/a | yes |
| <a name="input_service_plan_sku_name"></a> [service\_plan\_sku\_name](#input\_service\_plan\_sku\_name) | The SKU name of the Azure service plan | `string` | `"Y1"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The backend storage account name which will be used by this Function App | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the Azure resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_insights_id"></a> [application\_insights\_id](#output\_application\_insights\_id) | ID of the associated Application Insights |
| <a name="output_application_insights_name"></a> [application\_insights\_name](#output\_application\_insights\_name) | Name of the associated Application Insights |
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | The default hostname of the Linux Function App |
| <a name="output_function_app_id"></a> [function\_app\_id](#output\_function\_app\_id) | The ID of the function app |
| <a name="output_function_app_name"></a> [function\_app\_name](#output\_function\_app\_name) | The name of the function app |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | The ID of the service plan |
| <a name="output_service_plan_name"></a> [service\_plan\_name](#output\_service\_plan\_name) | The name of the service plan |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the storage account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the storage account |

## Authors

Modules managed by [diodonfrost](https://github.com/diodonfrost)

## Licence

Apache 2 Licensed. See LICENSE for full details.

## Resources

* [python function app](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-python)
