output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "vm_private_ip" {
  value = azurerm_network_interface.example.private_ip_address
}

output "bastion_ip" {
  value = azurerm_public_ip.example.ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "storage_container_name" {
  value = azurerm_storage_container.example.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.example.name
}

output "subnet_names" {
  value = [azurerm_subnet.example.name, azurerm_subnet.bastion.name]
}

output "vm_identity_principal_id" {
  value = azurerm_linux_virtual_machine.example.identity[0].principal_id
}

