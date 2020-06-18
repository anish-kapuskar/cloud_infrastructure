
provider "aws" {
    region="${var.region}"  
}

module "vpc_module" {
  source ="/home/anishkapuskar/cloudapps/infrastructure/modules"
 vpc_cidr="${var.vpc_cidr}"
subnet1_cidr="${var.subnet1_cidr}"
s1az="${var.s1az}"
subnet2_cidr="${var.subnet2_cidr}"
s2az="${var.s2az}"
 
} 


