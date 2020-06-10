
provider "aws" {
    region="us-east-1"  
}


module "vpc_module" {
  source ="/home/anishkapuskar/cloud/terraform/modules"

  vpc_cidr ="10.0.0.0/16"
  subnet1_cidr="10.0.1.0/24"

  
  subnet2_cidr="10.0.2.0/24"
  
  subnet3_cidr="10.0.3.0/24"
  

}