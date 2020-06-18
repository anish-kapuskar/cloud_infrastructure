
resource "aws_vpc" "csye6225_a4_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink_dns_support = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "csye6225_a4_vpc"
  }
}


resource "aws_subnet" "subnet1" {
    cidr_block              = "${var.subnet1_cidr}"
    vpc_id                  ="${aws_vpc.csye6225_a4_vpc.id}"
    availability_zone       = "${var.s1az}"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
    cidr_block              = "${var.subnet2_cidr}"
    vpc_id                  ="${aws_vpc.csye6225_a4_vpc.id}"
    availability_zone       = "${var.s2az}"
    map_public_ip_on_launch = true

}





resource "aws_internet_gateway" "csye6225_a4_internet_gateway" {
  vpc_id = "${aws_vpc.csye6225_a4_vpc.id}"

  tags = {
    Name = "a4_Internet gateway"
  }
}

resource "aws_route_table" "csye6225_a4_route_table" {
  vpc_id = "${aws_vpc.csye6225_a4_vpc.id}"

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.csye6225_a4_internet_gateway.id}"
  }

  tags = {
    Name = "a4_route_table"
  }
}

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.csye6225_a4_route_table.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.csye6225_a4_route_table.id
}



resource "aws_security_group" "application" {
  name        = "application"
  description = "Allow TCP inbound traffic"
  vpc_id      = "${aws_vpc.csye6225_a4_vpc.id}"

  ingress {
    description = "TCP traffic from anywhere in the world"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP traffic from anywhere in the world"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP traffic from anywhere in the world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP traffic from anywhere in the world"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "application"
  }
}

resource "aws_security_group" "database" {
  name        = "database"

  vpc_id      = "${aws_vpc.csye6225_a4_vpc.id}"

  ingress { 
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  tags = {
    Name = "database"
  }
}

resource "aws_security_group_rule" "database_rule" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"

  security_group_id = aws_security_group.database.id
  source_security_group_id = aws_security_group.application.id
}

resource "aws_kms_key" "a5_key" {
  description             = "This key is used to encrypt bucket objects"
}

resource "aws_s3_bucket" "webapp-anish-kapuskar" {
  bucket = "webapp.anish.kapuskar"
  force_destroy = true
  acl    = "private"
   
    lifecycle_rule {
    id      = "a5_rule"
    enabled = true

    tags = {
      "rule"      = "a5_rule"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

  }

server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.a5_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "webapp.anish.kapuskar"
    Environment = "dev"
  }
}

resource "aws_db_subnet_group" "a5_subnet_group" {
  name       = "a5_subnet_group"
  subnet_ids = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "csye6225" {
  
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  identifier           = "csye6225-su2020"
  instance_class       = "db.t3.micro"
  name                 = "csye6225"
  username             = "csye6225su2020"
  password             = "anishk78995"
  parameter_group_name = "default.mysql5.7"
  multi_az             = false
  publicly_accessible  = false
  skip_final_snapshot  = true 
  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name = "${aws_db_subnet_group.a5_subnet_group.name}"	
}


resource "aws_key_pair" "csye6225_a5_key" {
  key_name   = "csye6225_a5_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeYzkIrUTqb0e4VpD20LfmCrfrDKDgXlfLvNRNCpdvmk58AH8lcNRysms6ZY4fuJP/fJKOb+JH3ZCRZ0SisLzgCuLU7u++H6kCjF24xyvcZ/b6LPip6/85z8+RPGW4z5xgVoFZ7VEqNa1P89XpYbawpkWIX5g+dh6rDGKYb9eM/s9bGXXILngJbVkV7xmdlsc1qh74DDlFmYLDQYBDXtl1WvPM6zDgSgV8eP+KIXYEo0tKewA0PlsP5nyvNIIx/wtuUdvxoGdZg/mrpto0vsCS8j5eKg6M9tS9WaveM05GXfKiAfBFvXZJKRHhS0baEKSZjO5sq3lueECfjTqEjHIr anishkapuskar@anish-kapuskar"
}


data "aws_ami" "a5_ami" {
  most_recent = true

 owners = ["701208723174","569196275084"]
}



resource "aws_instance" "a5_ec2_instance" {
  ami           = "${data.aws_ami.a5_ami.id}"
  instance_type = "t2.micro"
  disable_api_termination = false
  vpc_security_group_ids = [aws_security_group.application.id]
  subnet_id = "${aws_subnet.subnet1.id}"

  depends_on = [aws_db_instance.csye6225]
  iam_instance_profile    = "${aws_iam_instance_profile.ec2_profile.name}"

  key_name                = "${aws_key_pair.csye6225_a5_key.key_name}"


   user_data = <<-EOF
          #!/bin/bash
          echo "export db_hostname=${aws_db_instance.csye6225.address}">>/home/ubuntu/.bashrc
          echo "export db_username=csye6225su2020">>/home/ubuntu/.bashrc
          echo "export db_password=anishk78995">>/home/ubuntu/.bashrc
          echo "export s3_bucket_name=webapp.anish.kapuskar">>/home/ubuntu/.bashrc
      EOF

  root_block_device {
  volume_type = "gp2"
  volume_size = 20
  }

 ebs_block_device {
 device_name = "/dev/sda1"
 volume_type = "gp2"
 volume_size = 20
 delete_on_termination = true
 }

  tags = {
    Name = "a5_ec2_instance"
  }
}


resource "aws_dynamodb_table" "csye6225" {
  name           = "csye6225"
  hash_key       = "id"
  read_capacity  = 20
  write_capacity = 20

 attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "csye6225"
  }
}


resource "aws_iam_policy" "WebAppS3" {
  name        = "WebAppS3"
  description = "S3 bucket policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
          ],
          "Effect": "Allow",
          "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.webapp-anish-kapuskar.bucket}",
              "arn:aws:s3:::${aws_s3_bucket.webapp-anish-kapuskar.bucket}/*"
          ]
      }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.ec2_s3_role.name}"
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "EC2-CSYE6225"

  assume_role_policy = "${file("ec2s3role.json")}"

  tags = {
    Name = "EC2-Iam role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = "${aws_iam_role.ec2_s3_role.name}"
  policy_arn = "${aws_iam_policy.WebAppS3.arn}"
}








