terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
        }
    }
    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region  = var.regiao_aws
}

resource "aws_launch_template" "backendTemplate" {
    image_id      = "ami-0309940e1960b7b7e"
    instance_type = var.instancia
    key_name = var.chave
    tags = {
        Name = "templateBackend"
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "backend"
        }
    }
    user_data = filebase64("EC2BackInit.sh")

    network_interfaces {
        associate_public_ip_address = false
        security_groups = [aws_security_group.EC2BackendAccess.id]
    }

    iam_instance_profile {
        name = aws_iam_instance_profile.EC2Profile.name
    }
}

resource "aws_launch_template" "frontendEC2Template" {
    image_id      = "ami-0cb74abb5cb1db1e9"
    instance_type = var.instancia
    key_name = var.chave
    tags = {
        Name = "frontendEC2Template"
    }
}

resource "aws_launch_template" "publicEC2Template" {
    image_id      = "ami-03d5c68bab01f3496"
    instance_type = var.instancia
    key_name = var.chave
    tags = {
        Name = "publicEC2Template"
    }
}

resource "aws_instance" "bastionEC2Instance"{
    launch_template {
        id = aws_launch_template.publicEC2Template.id
        version = "$Latest"
    }
    tags = {
        Name  = "bastion"
    }
    count = 1
    associate_public_ip_address = true
    availability_zone = "us-west-2a"
    subnet_id = aws_subnet.publicSubnet.id
    
    vpc_security_group_ids = [aws_security_group.EC2PublicAccess.id]

    iam_instance_profile = aws_iam_instance_profile.EC2Profile.name
}

resource "aws_instance" "reverseProxyEC2Instance"{
    launch_template {
        id = aws_launch_template.publicEC2Template.id
        version = "$Latest"
    }
    tags = {
        Name  = "reverseProxy"
    }
    associate_public_ip_address = true
    availability_zone = "us-west-2a"
    subnet_id = aws_subnet.publicSubnet.id
    user_data = filebase64("EC2ProxyInit.sh") 
    vpc_security_group_ids = [aws_security_group.EC2PublicAccess.id]

    iam_instance_profile = aws_iam_instance_profile.EC2Profile.name
}

resource "aws_instance" "frontendEC2Instance"{
    launch_template {
        id = aws_launch_template.frontendEC2Template.id
        version = "$Latest"
    }
    tags = {
        Name  = "frontend"
    }
    count = 1

    user_data = filebase64("EC2FrontInit.sh") 
    associate_public_ip_address = false
    private_ip = "10.0.1.200"

    subnet_id = aws_subnet.publicSubnet.id
    vpc_security_group_ids = [aws_security_group.EC2FrontendAccess.id]

    iam_instance_profile = aws_iam_instance_profile.EC2Profile.name
}




