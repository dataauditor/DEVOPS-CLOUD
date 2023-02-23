terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.58.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.8.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.6.0"
    }
    bitbucket = {
      source = "aeirola/bitbucket"
      version = "1.3.0"
    }
  }
}
provider "aws" {}
provider "azurerm" {
  features {}
}
provider "gitlab" {}
provider "docker" {}
provider "bitbucket" {}
provider "digitalocean" {}