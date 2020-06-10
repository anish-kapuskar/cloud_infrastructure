

variable  "vpc_cidr" {
    type = string
    
}
variable  "subnet1_cidr" {
    type = string
    default= "10.0.1.0/24"
}
variable  "s1az" {
    type = string
    
}
variable  "subnet2_cidr" {
    type = string
    default= "10.0.2.0/24"
}
variable  "s2az" {
    type = string
    
}
variable  "subnet3_cidr" {
    type = string
    default= "10.0.3.0/24"
}
variable  "s3az" {
    type = string
    
}

