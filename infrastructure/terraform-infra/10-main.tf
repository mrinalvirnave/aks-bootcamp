# Configure the Azure Provider
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.76.0"
    }
  }
  required_version = ">= 0.15"
  backend "azurerm" {
    subscription_id = "13ad1203-e6d5-4076-bf2b-73465865f9f0"
    storage_account_name = "tcdemos"
    container_name       = "aks-bootcamp"
    key                  = "infra.tfstate"
    # for security reasons we don't specify the access_key here.  instead set the environment variable ARM_ACCESS_KEY.
  }
}

resource "azurerm_resource_group" "testbed" {
  location = var.location
  name = "RG-${var.country}-${var.region}-${var.suffix}"
}