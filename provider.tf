terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  #   backend "azurerm" {
  #         resource_group_name  = ""
  #         container_name       = ""
  #         key                  = ""
  #     }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}