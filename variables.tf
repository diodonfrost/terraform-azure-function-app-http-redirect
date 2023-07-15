variable "function_app_name_prefix" {
  type        = string
  description = "The prefix of the Azure Function App name"
}

variable "service_plan_name" {
  type        = string
  description = "The name of the Azure service plan"
}

variable "service_plan_sku_name" {
  type        = string
  description = "The SKU name of the Azure service plan"
  default     = "Y1"
}

variable "storage_account_name" {
  type        = string
  description = "The backend storage account name which will be used by this Function App"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the Linux Function App should exist"
}

variable "location" {
  type        = string
  description = "The location of the Azure resources"
}

variable "redirect_mappings" {
  type        = map(string)
  description = "A key/value map of source domain name -> target url redirects."
}

variable "http_redirect_code" {
  type        = string
  description = "Which HTTP redirect code to use"
  default     = "301"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to the Azure resources"
  default     = {}
}
