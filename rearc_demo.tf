provider "aws" {
  region     = "ca-central-1"
  access_key = "AKIAZBVFPMVE4E44RUHK"
  secret_key = "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"
}
resource "aws_key_pair" "deployer" {
  key_name   = "my-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCj81HiYeYVN5jP+bQ4UeiM2IeHPz+kYOUnQ8jXmwHUVzDAhaTUJ0nNzRCelo1aXgO0MoaIqN4FuUeDGQK+v2OS2FW1q66fdscvqik8jG9++3MeHU3lZkad42p3ly/QPG6fVnKQhXzejk0/e2SZcGgXgYX3H/T/rGar2TqLHRbJDREvBrZfs2V8lBjW7MXXWN6ka7Ot9qo1+uB8Yshf7TdkJadW35FuM3PKUUHXWk3RdI4Se8uz1jrnpqOl+iDcdHEH5bVD/J5JJt/cRe+KQDMKcA6CppwwJP8HjBNm9UOyYyJV9LGWuy0P6oUL76jAswzwMnTCTQJdN815HoB2kwSP prakhar"
}

resource "aws_instance" "rearc_demo"{
    ami="ami-0bceafb1c9a741e35"
    instance_type="t2.micro"
    key_name="prak"
      tags = {
      Name = "rearc_demo"
  }
}

//resource "aws_vpc" "main" {
//  cidr_block = "10.0.0.0/16"
//}

//resource "aws_subnet" "subnet1" {
//  vpc_id     = aws_vpc.main.id
//  cidr_block = "10.0.1.0/24"
//}

//resource "aws_subnet" "subnet2" {
//  vpc_id     = aws_vpc.main.id
//  cidr_block = "10.0.1.0/24"
//}

//resource "aws_security_group" "rearc_security" {
//  name        = "allow_tls"
//  description = "Allow TLS inbound traffic"
//  vpc_id      = aws_vpc.main.id

//  ingress {
//    description      = "Traffic from VPC"
//    from_port        = 22
//    to_port          = 3000
//    protocol         = "tcp"
//   cidr_blocks      = [aws_vpc.main.cidr_block]
//  ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
//  }

//  egress {
//    from_port        = 0
//    to_port          = 0
//    protocol         = "-1"
//    cidr_blocks      = ["0.0.0.0/0"]
//    ipv6_cidr_blocks = ["::/0"]
//  }

//  tags = {
//    Name = "rearc_security"
//  }
//}
//resource "aws_lb_target_group" "target_quest" {
//  name     = "quest-target-tf"
//  port     = 80
//  protocol = "HTTP"
//  vpc_id   = "vpc-0fd7eb7bf8c1bf4f8"
//}

//resource "aws_lb_target_group_attachment" "test" {
 // target_group_arn = aws_lb_target_group.target_quest.arn
 // target_id        = aws_instance.rearc_demo.id
 // port             = 3000
//}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-alb"

  load_balancer_type = "application"

 vpc_id             = "vpc-0fd7eb7bf8c1bf4f8"
 subnets            = ["subnet-03513fade0a489daa", "subnet-00c36bfc43ce939d7"]
 security_groups    = ["sg-014a7634573ecc652"]

 //vpc_id             = "${aws_vpc.main.id}"
 //subnets            = ["${aws_subnet.subnet1.id}", "${aws_subnet.subnet2.id}"]
 //security_groups    = ["${aws_security_group.rearc_security.id}"]

 // access_logs = {
 //   bucket = "my-alb-logs"
  //}

  target_groups = [
    {
      name      = "rearctarget"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "${aws_instance.rearc_demo.id}"
          port = 3000
        }
      ]
    }
  ]

 // https_listeners = [
 //   {
 //     port               = 443
 //     protocol           = "HTTPS"
 //     certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
 //     target_group_index = 0
 //   }
 // ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}

