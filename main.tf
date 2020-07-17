
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
subnet3_cidr="${var.subnet3_cidr}"
s3az="${var.s3az}"
subnet4_cidr="${var.subnet4_cidr}"
s4az="${var.s4az}"
subnet5_cidr="${var.subnet5_cidr}"
s5az="${var.s5az}"
subnet6_cidr="${var.subnet6_cidr}"
s6az="${var.s6az}"
custom_ami="${var.custom_ami}"
 
} 


