# Define the subnet for Azure Bastion
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/27"]
  depends_on = [
    azurerm_virtual_network.example
  ]
}

# Define the Azure Bastion host
resource "azurerm_bastion_host" "example" {
  name                = "${var.prefix}-bastion"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                 = "bastionIpConfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

# Define the public IP address for the Bastion host
resource "azurerm_public_ip" "example" {
  name                = "${var.prefix}-bastion-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}