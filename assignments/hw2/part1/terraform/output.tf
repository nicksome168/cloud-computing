output "secondary_access_key"{
    value = azurerm_storage_account.storage_ac.secondary_access_key
    sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}