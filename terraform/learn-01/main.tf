terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.23"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_group" "developers" {
    name = "developers"
}