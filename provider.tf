#Past this in provider.tf file
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.8.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region

}


#Past this in the root directory module main.tf file

module "ec2_instance" {
  source        = "./modules/ec2"
  instance_type = "t2.micro"
  image_os      = "ubuntu"
  tagging = {
    "name" = "maureen-instance"
    "BusinessUnit" = "infosec"
  }
}

#Root directory module variable .tf file

variable "aws_region" {
    type = string
    description = "Region to deploy our resources"
    default = "us-east-1"
  
}

variable "tagging" {
  type = map(string)
  default = {
    name         = "maureen-instance"
    BusinessUnit = "infosec"
  }
}
  

