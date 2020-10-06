
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
    vpc_id                  = "${aws_vpc.csye6225_a4_vpc.id}"
    availability_zone       = "${var.s2az}"
    map_public_ip_on_launch = true

}
resource "aws_subnet" "subnet3" {
    cidr_block              = "${var.subnet3_cidr}"
    vpc_id                  ="${aws_vpc.csye6225_a4_vpc.id}"
    availability_zone       = "${var.s3az}"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet4" {
    cidr_block              = "${var.subnet4_cidr}"
    vpc_id                  = "${aws_vpc.csye6225_a4_vpc.id}"
    availability_zone       = "${var.s4az}"
    map_public_ip_on_launch = true

}
resource "aws_subnet" "subnet5" {
    cidr_block              = "${var.subnet5_cidr}"
    vpc_id                  ="${aws_vpc.csye6225_a4_vpc.id}"
    availability_zone       = "${var.s5az}"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet6" {
    cidr_block              = "${var.subnet6_cidr}"
    vpc_id                  = "${aws_vpc.csye6225_a4_vpc.id}"
    availability_zone       = "${var.s6az}"
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

resource "aws_route_table_association" "subnet3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.csye6225_a4_route_table.id
}

resource "aws_route_table_association" "subnet4" {
  subnet_id      = aws_subnet.subnet4.id
  route_table_id = aws_route_table.csye6225_a4_route_table.id
}


resource "aws_route_table_association" "subnet5" {
  subnet_id      = aws_subnet.subnet5.id
  route_table_id = aws_route_table.csye6225_a4_route_table.id
}

resource "aws_route_table_association" "subnet6" {
  subnet_id      = aws_subnet.subnet6.id
  route_table_id = aws_route_table.csye6225_a4_route_table.id
}




resource "aws_security_group" "lb_security" {
  name        = "lb_security"
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
  ingress {
    description = "TCP traffic from anywhere in the world"
    from_port   = 3306
    to_port     = 3306
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
    Name = "lb_security"
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


resource "aws_security_group" "application" {
  name        = "application"

  vpc_id      = "${aws_vpc.csye6225_a4_vpc.id}"

#  ingress { 
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    security_groups = ["${aws_security_group.lb_security.id}"]
#  }
  
#   egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

    ingress { 
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = ["${aws_security_group.lb_security.id}"]
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
    security_groups = ["${aws_security_group.lb_security.id}"]
  }
  

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
  ingress {
    description = "TCP traffic from anywhere in the world"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${aws_security_group.lb_security.id}"]
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

resource "aws_security_group_rule" "database_rule" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"

  security_group_id = aws_security_group.database.id
  source_security_group_id = aws_security_group.lb_security.id
}

resource "aws_security_group_rule" "database_rule_asg" {
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

  tags = {
    Name        = "webapp.anish.kapuskar"
    Environment = "prod"
  }
}

resource "aws_s3_bucket" "codedeploy-anishkapuskar-me" {
  bucket = "codedeploy.anishkapuskar.me"
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


  tags = {
    Name        = "codedeploy.anishkapuskar.me"
    Environment = "prod"
  }
}

resource "aws_db_subnet_group" "a5_subnet_group" {
  name       = "a5_subnet_group"
  subnet_ids = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}", "${aws_subnet.subnet3.id}", "${aws_subnet.subnet4.id}", "${aws_subnet.subnet5.id}", "${aws_subnet.subnet6.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "csye6225" {
  
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  identifier           = "csye6225-su2020"
  instance_class       = "db.t3.micro"
  name                 = "csye6225"
  username             = ""
  password             = ""
  parameter_group_name = "mysql8paramgroup"
  multi_az             = false
  publicly_accessible  = false
  skip_final_snapshot  = true 
  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name = "${aws_db_subnet_group.a5_subnet_group.name}"
  storage_encrypted    = true
}


resource "aws_db_parameter_group" "mysql8paramgroup" {
  name   = "mysql8paramgroup"
  family = "mysql8.0"

  parameter {
    name  = "performance_schema"
    value = "1"
    apply_method = "pending-reboot"
  }
}






resource "aws_key_pair" "csye6225_a5_key" {
  key_name   = "csye6225_a5_key"
  public_key = ""
}
















resource "aws_dynamodb_table" "csye6225" {
  name           = "csye6225"
  hash_key       = "username"
  read_capacity  = 20
  write_capacity = 20

 attribute {
    name = "username"
    type = "S"
  }

 ttl {
    attribute_name = "username"
    enabled        = true
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

resource "aws_iam_policy" "CodeDeploy-EC2-S3" {
  name        = "CodeDeploy-EC2-S3"
  description = "CodeDeploy-EC2-S3 policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.codedeploy-anishkapuskar-me.bucket}",
              "arn:aws:s3:::${aws_s3_bucket.codedeploy-anishkapuskar-me.bucket}/*"
              ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "CircleCI-Upload-To-S3" {
  name        = "CircleCI-Upload-To-S3"
  description = "CircleCI-Upload-To-S3 policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                        "arn:aws:s3:::${aws_s3_bucket.codedeploy-anishkapuskar-me.bucket}",
              "arn:aws:s3:::${aws_s3_bucket.codedeploy-anishkapuskar-me.bucket}/*",
              "arn:aws:s3:::lambdacsye6225",
              "arn:aws:s3:::lambdacsye6225/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "CircleCI-Code-Deploy" {
  name        = "CircleCI-Code-Deploy"
  description = "CircleCI-Code-Deploy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": [
        "arn:aws:codedeploy:us-east-1:569196275084:application:csye6225-webapp"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": [
        "arn:aws:codedeploy:us-east-1:569196275084:deploymentconfig:CodeDeployDefault.OneAtATime",
        "arn:aws:codedeploy:us-east-1:569196275084:deploymentconfig:CodeDeployDefault.HalfAtATime",
        "arn:aws:codedeploy:us-east-1:569196275084:deploymentconfig:CodeDeployDefault.AllAtOnce"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "circleci-ec2-ami" {
  name        = "circleci-ec2-ami"
  description = "circleci-ec2-ami"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeyPair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}




resource "aws_iam_policy" "CircleCI-lambda" {
  name        = "CircleCI-lambda"
  description = "CircleCI update lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ActionsWhichSupportResourceLevelPermissions",
            "Effect": "Allow",
            "Action": [
                "lambda:AddPermission",
                "lambda:RemovePermission",
                "lambda:CreateAlias",
                "lambda:UpdateAlias",
                "lambda:DeleteAlias",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "lambda:PutFunctionConcurrency",
                "lambda:DeleteFunctionConcurrency",
                "lambda:PublishVersion"
            ],
            "Resource": "arn:aws:lambda:us-east-1:569196275084:function:lambdaapp"
        },
        {
            "Sid": "ActionsWhichSupportCondition",
            "Effect": "Allow",
            "Action": [
                "lambda:CreateEventSourceMapping",
                "lambda:UpdateEventSourceMapping",
                "lambda:DeleteEventSourceMapping"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "lambda:FunctionArn": "arn:aws:lambda:us-east-1:569196275084:function:lambdaapp"
                }
            }
        },
        {
            "Sid": "ActionsWhichDoNotSupportResourceLevelPermissions",
            "Effect": "Allow",
            "Action": [
                "lambda:UntagResource",
                "lambda:TagResource"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}







resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
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







resource "aws_iam_role" "CodeDeployEC2ServiceRole" {
  name = "CodeDeployEC2ServiceRole"

  assume_role_policy = "${file("codedeployrole.json")}"

  tags = {
    Name = "CodeDeployEC2ServiceRole"
  }
}

resource "aws_iam_role_policy_attachment" "CodeDeployEC2ServiceRole_attach" {
  role       = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
  policy_arn = "${aws_iam_policy.CodeDeploy-EC2-S3.arn}"
}

resource "aws_iam_role_policy_attachment" "CloudWatchEC2_attach" {
  role       = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_SNS_attach" {
	role = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
	policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_ec2_attach" {
  role       = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}




resource "aws_iam_role" "CodeDeployServiceRole" {
  name = "CodeDeployServiceRole"

  assume_role_policy = "${file("codedeployrole.json")}"

  tags = {
    Name = "CodeDeployServiceRole"
  }
}

resource "aws_iam_role_policy_attachment" "CodeDeployServiceRole_attach" {
  role       = "${aws_iam_role.CodeDeployServiceRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}




resource "aws_codedeploy_app" "csye6225-webapp" {
  compute_platform = "Server"
  name             = "csye6225-webapp"
}













resource "aws_iam_user_policy_attachment" "CircleCI-Upload-To-S3-user-attach" {
  user       = "circleci"
  policy_arn = "${aws_iam_policy.CircleCI-Upload-To-S3.arn}"
}


resource "aws_iam_user_policy_attachment" "CircleCI-Code-Deploy-user-attach" {
  user       = "circleci"
  policy_arn = "${aws_iam_policy.CircleCI-Code-Deploy.arn}"
}


resource "aws_iam_user_policy_attachment" "circleci-ec2-ami-user-attach" {
  user       = "circleci"
  policy_arn = "${aws_iam_policy.circleci-ec2-ami.arn}"
}

resource "aws_iam_user_policy_attachment" "circleci-lambda-attach" {
  user       = "circleci"
  policy_arn = "${aws_iam_policy.CircleCI-lambda.arn}"
}















resource "aws_autoscaling_group" "csye6225_asg" {
  name                      = "csye6225-asg"
  max_size                  = 5
  min_size                  = 2
  default_cooldown          = 60
  target_group_arns         = ["${aws_lb_target_group.csye6225_target_group.arn}"]
  health_check_grace_period = 300
  health_check_type         = "EC2"

  launch_configuration      = "${aws_launch_configuration.asg_launch_config.name}"
  vpc_zone_identifier       = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}", "${aws_subnet.subnet3.id}", "${aws_subnet.subnet4.id}", "${aws_subnet.subnet5.id}", "${aws_subnet.subnet6.id}"]
 
 tag {
      key                 = "Name"
      value               = "asg_ec2_instance"
      propagate_at_launch = true
    }

  lifecycle {
    create_before_destroy = true
  }

}




resource "aws_autoscaling_policy" "WebServerScaleUpPolicy" {
  name                   = "WebServerScaleUpPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.csye6225_asg.name}"
}

resource "aws_autoscaling_policy" "WebServerScaleDownPolicy" {
  name                   = "WebServerScaleDownPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.csye6225_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmHigh" {
  alarm_name          = "CPUAlarmHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "180"
  statistic           = "Average"
  threshold           = "90"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.csye6225_asg.name}"
  }

  alarm_description = "Scale-up if CPU > 5% for 10 minutes"
  alarm_actions     = ["${aws_autoscaling_policy.WebServerScaleUpPolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmLow" {
  alarm_name          = "CPUAlarmLow"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "180"
  statistic           = "Average"
  threshold           = "3"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.csye6225_asg.name}"
  }

  alarm_description = "Scale-down if CPU < 3% for 10 minutes"
  alarm_actions     = ["${aws_autoscaling_policy.WebServerScaleDownPolicy.arn}"]
}








resource "aws_launch_configuration" "asg_launch_config" {
  name                        = "asg_launch_config"
  image_id                    = "${var.custom_ami}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.csye6225_a5_key.key_name}"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.ec2_profile.name}"
  security_groups             = ["${aws_security_group.application.id}"]
  depends_on = [aws_db_instance.csye6225] 

  user_data = <<-EOF
          #!/bin/bash
          sudo echo export "DB_HOSTNAME='${aws_db_instance.csye6225.address}'" >> /etc/environment
          sudo echo export "DB_USERNAME=''" >> /etc/environment
          sudo echo export "DB_PASSWORD=''" >> /etc/environment
          sudo echo export "S3_BUCKET_NAME='webapp.anish.kapuskar'" >> /etc/environment
     EOF

    lifecycle {
    create_before_destroy = true
  }

}




resource "aws_lb" "csye6225_lb" {
  name               = "csye6225-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = ["${aws_security_group.lb_security.id}"]
  subnets            = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}", "${aws_subnet.subnet3.id}", "${aws_subnet.subnet4.id}", "${aws_subnet.subnet5.id}", "${aws_subnet.subnet6.id}"]



  tags = {
    Environment = "production"
  }
}



# resource "aws_lb_listener" "httplb" {
#   load_balancer_arn = "${aws_lb.csye6225_lb.arn}"
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_lb_target_group.csye6225_target_group.arn}"
#   }
# }

resource "aws_lb_listener" "httpslb" {
  load_balancer_arn = "${aws_lb.csye6225_lb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:569196275084:certificate/0f6112f9-d134-4b06-b1e4-24ada9c79cdc"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.csye6225_target_group.arn}"
  }
}


resource "aws_lb_target_group" "csye6225_target_group" {
  name     = "csye6225-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.csye6225_a4_vpc	.id}"
}



resource "aws_route53_record" "route53_lb" {
  zone_id = ""
  name    = "prod.anishkapuskar.me"
  type    = "A"

  alias {
    name                   = "${aws_lb.csye6225_lb.dns_name}"
    zone_id                = "${aws_lb.csye6225_lb.zone_id}"
    evaluate_target_health = false
  }
}




resource "aws_codedeploy_deployment_group" "csye6225-webapp-deployment" {
  app_name              = "${aws_codedeploy_app.csye6225-webapp.name}"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name = "csye6225-webapp-deployment"
  service_role_arn      = "${aws_iam_role.CodeDeployServiceRole.arn}"
  autoscaling_groups    = ["${aws_autoscaling_group.csye6225_asg.name}"]

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "asg_ec2_instance"
    }

  }


  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

}






resource "aws_sns_topic" "csye6225_sns_topic" {
  name = "password_reset"
}





resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_lambda_attach" {
  role       = "${aws_iam_role.lambda_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_lambda_attach" {
  role       = "${aws_iam_role.lambda_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "ses_lambda_attach" {
  role       = "${aws_iam_role.lambda_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_lambda_attach" {
  role       = "${aws_iam_role.lambda_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_SNS_attach" {
	role = "${aws_iam_role.lambda_iam_role.name}"
	policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}



resource "aws_lambda_function" "csye6225_lambda_function" {
  filename      = "lambdaapp-1.0-SNAPSHOT.jar"
  function_name = "lambdaapp"
  role          = "${aws_iam_role.lambda_iam_role.arn}"
  handler       = "lambdaapp::handleRequest"

  source_code_hash = "${filebase64sha256("lambdaapp-1.0-SNAPSHOT.jar")}"

  runtime = "java8"

  memory_size = 256

  timeout = 300
  

  environment {
    variables = {
      DynamoDBEndPoint = "dynamodb.us-east-1.amazonaws.com",
      TTL_MINS = "15",
      domain = "prod.anishkapuskar.me"   
    }
  }
}



resource "aws_lambda_permission" "csye6225_lambda_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.csye6225_lambda_function.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.csye6225_sns_topic.arn}"
}

resource "aws_sns_topic_subscription" "csye6225_sns_subscription" {
  topic_arn = "${aws_sns_topic.csye6225_sns_topic.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.csye6225_lambda_function.arn}"
}

