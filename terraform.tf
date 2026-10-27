terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
  }
}
