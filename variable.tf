# Prefix for resource names to ensure uniqueness
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

# Azure region for resources
variable "location" {
  description = "Azure region for resources"
  type        = string
}

# Admin username for the virtual machine
variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

# Admin password for the virtual machine (sensitive information)
variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
}
