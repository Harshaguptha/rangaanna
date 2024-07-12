terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
      storage_account_name = "statefilegithubactions"
      container_name       = "tfstate"
      key                  = "secupi-dev-harsha-ranga.tfstate"
  }
}
