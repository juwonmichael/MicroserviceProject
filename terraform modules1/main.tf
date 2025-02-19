terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
    
  }
provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraformstatebucket12790"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraformlocktable12790"
    
  }
}

 
module "vpc" {  
  source = "./Modules/vpc"
  cluster_name = var.cluster_name
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs


  
}

module "eks" {
  source = "./Modules/eks"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  node_groups = var.node_groups

}