# Secure Azure VM Access with Managed Identity and Terraform

## Problem Statement
At **FinSecure Inc.**, a leading financial services provider, the cloud security team identified a significant issue in the infrastructure. Their Azure Virtual Machines (VMs) were accessing sensitive resources such as Azure Storage accounts and Key Vault using hardcoded credentials. This practice was risky, especially for a company handling sensitive financial data, as it exposed the environment to potential security breaches and compliance violations.

The team had also noticed challenges with auditing access and ensuring secure management of VMs. They needed a solution that would:
- Eliminate the use of hardcoded credentials.
- Ensure secure, auditable access to critical resources without compromising security.
- Allow secure management of the VMs, without exposing them directly to the internet.

As a **Cloud Infrastructure Engineer** at FinSecure Inc., I was tasked with resolving these issues. The goal was to redesign the environment to securely manage VM access and eliminate hardcoded credentials.

## Solution
To solve the problem, I:
1. Deployed a **Linux VM** in a secure network environment with **SSH key-based authentication**.
2. Assigned a **managed identity** to the VM, granting it access to an Azure Storage Account with the **Storage Blob Data Contributor** role.
3. Set up a **Bastion host** for secure access to the VM over SSH without exposing it directly to the internet.
4. Configured the **CI/CD pipeline** in **Azure DevOps** to automate the Terraform deployment process, ensuring consistent and repeatable infrastructure creation.

## Implementation Details

### 1. Terraform Configuration:
- **Resource Group**: Created to logically group and manage the resources.
- **Storage Account & Container**: Set up for secure data storage, with a private container for data management.
- **Virtual Network & Subnet**: Configured a virtual network and subnet for secure communication between resources.
- **Network Interface & Security**: Attached a **Network Interface (NIC)** to the VM for network connectivity.
- **Linux VM**: Deployed with **SSH key-based authentication** and a **system-assigned managed identity** to securely access Azure resources.
- **Role Assignment**: The VM’s managed identity was granted the **Storage Blob Data Contributor** role to interact with the storage account.
- **Bastion Host**: Configured in a dedicated subnet for **secure SSH access** to the VM, without exposing it to the internet.

### 2. CI/CD Pipeline Configuration (Azure DevOps):
- **Automated Deployment**: The pipeline automates the deployment of the infrastructure using Terraform.
- **SSH Key Handling**: The pipeline securely fetches the SSH public key from a secure file in Azure DevOps and injects it into the Terraform configuration.
- **Terraform Commands**:
  - `terraform init`: Initializes the backend configuration to securely store the Terraform state.
  - `terraform validate`: Validates the Terraform configuration.
  - `terraform fmt`: Formats the configuration files according to Terraform standards.
  - `terraform plan`: Creates a plan for provisioning infrastructure.
  - `terraform apply`: Applies the Terraform plan to provision resources.
  - `terraform destroy`: Optionally, destroys the infrastructure after testing.

### 3. Security & Access:
- **SSH Key Authentication**: Used for secure access to the VM, eliminating the need for password-based login.
- **Azure Bastion**: Ensures that the VM is accessed without exposing public IP addresses.
- **Managed Identity**: Provides secure access to Azure Storage without storing credentials on the VM.

## Result
- The deployment was successful, eliminating hardcoded credentials from the system.
- **Azure Bastion** ensured secure, private access to the VM, removing the need for public IPs.
- Automation through **Terraform** and **Azure DevOps** made it easier to scale and maintain infrastructure, aligning with security and governance best practices.

## Testing the Solution

After deploying the infrastructure, I ran several commands inside the Linux VM to verify everything was functioning as expected. Here's how I tested the VM's access to Azure resources and its interaction with storage:

### 1. Testing Managed Identity Authentication:
To verify that the system-assigned managed identity was correctly enabled on the VM, I used the Azure CLI command:

az login --identity 

This command authenticates the VM using its managed identity without the need for any stored credentials.

### 2. Verifying Blob Storage Access: 
I ran the following command to list the blobs in the Azure Storage Account to ensure that the VM’s managed identity had the necessary permissions (i.e., Storage Blob Data Contributor role) to interact with the storage account:
az storage blob list --account-name manidsandgovstorage --container-name manidsandgovstoragecontainer --auth-mode login
This command returned an empty list, indicating that there were no blobs in the container.

### 3. Downloading a Random Image: 
To test the VM’s ability to download files from the internet, I used the curl command to fetch a random image:
curl -o random-image.png https://via.placeholder.com/150
This command downloaded the image and saved it as random-image.png.

### 4.Checking the File in the File System: 
I ran the following command to ensure that the downloaded file was correctly saved to the VM’s file system:
ls -l
The output confirmed that random-image.png was successfully downloaded and stored on the VM.

### 5. Uploading the Image to Azure Blob Storage: 
Finally, I uploaded the random-image.png to the Azure Storage Blob container using the Azure CLI:
az storage blob upload --account-name manidsandgovstorage --container-name manidsandgovstoragecontainer --name random-image.png --file random-image.png --auth-mode login
This command successfully uploaded the image to the storage container, confirming that the VM could interact with the storage account using its managed identity.

## Technologies & Tools Used:

Terraform:

Used for Infrastructure as Code (IaC) to define and manage Azure resources. With Terraform, I automated the provisioning of infrastructure, including the Linux virtual machine (VM), storage account, network, and Bastion host.

Azure DevOps:

CI/CD pipeline automation tool that handles the Terraform deployment process. It ensured that the entire infrastructure was deployed consistently and securely, including secure SSH key handling and pipeline integration for Terraform operations.

Azure Linux Virtual Machine (VM):

A Linux-based virtual machine was deployed with SSH key authentication for secure access. The VM was assigned a system-assigned managed identity to access Azure resources securely without needing hardcoded credentials. The Linux VM was used as the core computing resource for testing and interacting with other Azure services.

Azure Virtual Network (VNet):

Used to define a network boundary for Azure resources. The virtual network provided connectivity between the Linux VM and other resources while adhering to security best practices, such as segmentation and isolation of traffic.

Azure Subnet:

Subnets were created within the Virtual Network to segment traffic. The Linux VM was placed within a subnet, and an Azure Bastion subnet was also created for secure and private access to the VM.

Azure Bastion:

Azure Bastion provides secure, private access to the Linux virtual machine (VM) without exposing it to the public internet. This eliminates the need for a public IP address and adds an extra layer of security by allowing access to the VM only via Bastion.

Azure Managed Identity:

The system-assigned managed identity for the Linux VM enables it to access Azure resources (such as Azure Storage) securely without the need for storing credentials in the VM, adhering to best practices in identity and access management (IAM).
Azure Storage Account:

A Storage Account was used to securely store and access blobs and other data. The managed identity of the Linux VM was granted the Storage Blob Data Contributor role to interact with the storage account without compromising security.

Azure CLI:

The Azure CLI was used within the Linux VM to test the managed identity authentication and interact with Azure resources. Commands like az login --identity, az storage blob list, and az storage blob upload were used to verify access and functionality.

Azure Role-Based Access Control (RBAC):

RBAC was implemented using Terraform to assign the necessary roles (e.g., Storage Blob Data Contributor) to the Linux VM's managed identity, ensuring the right permissions were in place for secure access to Azure Storage.

SSH Key Authentication:
SSH key-based authentication was used to securely access the Linux VM. This eliminates the need for password-based authentication, ensuring that access is controlled via private/public key pairs, which is a more secure method for Linux environments.