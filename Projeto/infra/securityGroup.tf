resource "aws_security_group" "EC2PublicAccess" {
    name = "EC2PublicAccess"
    vpc_id   = aws_vpc.myvpc.id

    ingress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    ingress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    ingress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 443
        to_port = 443
        protocol = "tcp"
    }

    egress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    tags = {
        Name = "EC2Access"
    }
}

resource "aws_security_group" "EC2FrontendAccess" {
    name = "EC2FrontendAccess"
    vpc_id   = aws_vpc.myvpc.id

    ingress{
        cidr_blocks = [ "10.0.1.0/24" ]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    ingress{
        cidr_blocks = [ "10.0.1.0/24"]
        from_port = 3200
        to_port = 3200
        protocol = "tcp"
    }

    egress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    tags = {
        Name = "EC2Access"
    }
}

resource "aws_security_group" "EC2BackendAccess" {
    name = "EC2BackendAccess"
    vpc_id   = aws_vpc.myvpc.id

    ingress{
        cidr_blocks = [ "10.0.1.0/24" ]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }

    ingress{
        cidr_blocks = [ "10.0.2.0/24", "10.0.3.0/24", "0.0.0.0/0"]
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
    }

    egress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    tags = {
        Name = "EC2Access"
    }
}

resource "aws_security_group" "rdsAccess" {
    name = "rdsAccess"
    vpc_id   = aws_vpc.myvpc.id

    ingress{
        cidr_blocks = [ "10.0.2.0/24", "10.0.3.0/24" ]
        //ipv6_cidr_blocks = [ "::/0" ]
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
    }

    egress{
        cidr_blocks = [ "10.0.2.0/24", "10.0.3.0/24" ]
        #ipv6_cidr_blocks = [ "::/0" ]
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
    }

    tags = {
        Name = "EC2Access"
    }
}

resource "aws_security_group" "lbAccess" {
    name = "lbAccess"
    vpc_id   = aws_vpc.myvpc.id

    ingress{
        cidr_blocks = [ "10.0.1.0/24" ]
        //ipv6_cidr_blocks = [ "::/0" ]
        from_port = 80
        to_port = 80
        protocol = "tcp"
    }

    egress{
        cidr_blocks = [ "10.0.2.0/24", "10.0.3.0/24" ]
        #ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }

    tags = {
        Name = "EC2Access"
    }
}
