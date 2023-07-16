data "azurerm_dns_zone" "this" {
  for_each = var.custom_domains

  name                = each.value.dns_zone_name
  resource_group_name = each.value.dns_zone_resource_group_name
}

resource "azurerm_dns_cname_record" "this" {
  for_each = var.custom_domains

  name                = each.value.name
  zone_name           = data.azurerm_dns_zone.this[each.key].name
  resource_group_name = data.azurerm_dns_zone.this[each.key].resource_group_name
  ttl                 = 300
  record              = azurerm_linux_function_app.this.default_hostname
}

resource "azurerm_dns_txt_record" "this" {
  for_each = var.custom_domains

  name                = "asuid.${azurerm_dns_cname_record.this[each.key].name}"
  zone_name           = data.azurerm_dns_zone.this[each.key].name
  resource_group_name = data.azurerm_dns_zone.this[each.key].resource_group_name
  ttl                 = 300
  record {
    value = azurerm_linux_function_app.this.custom_domain_verification_id
  }
}

resource "azurerm_app_service_custom_hostname_binding" "this" {
  for_each = var.custom_domains

  hostname            = trim(azurerm_dns_cname_record.this[each.key].fqdn, ".")
  app_service_name    = azurerm_linux_function_app.this.name
  resource_group_name = azurerm_linux_function_app.this.resource_group_name
  depends_on          = [azurerm_dns_txt_record.this]

  # Ignore ssl_state and thumbprint as they are managed using
  # azurerm_app_service_certificate_binding.this
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_managed_certificate" "this" {
  for_each = var.custom_domains

  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.this[each.key].id
}

resource "azurerm_app_service_certificate_binding" "this" {
  for_each = var.custom_domains

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.this[each.key].id
  certificate_id      = azurerm_app_service_managed_certificate.this[each.key].id
  ssl_state           = "SniEnabled"
}
