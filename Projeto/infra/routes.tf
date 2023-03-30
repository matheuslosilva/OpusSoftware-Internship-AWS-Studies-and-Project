resource "aws_route53_zone" "privateRoute" {
  name = "projetoaws.com"

  vpc {
    vpc_id = aws_vpc.myvpc.id
  }
}

resource "aws_route53_record" "lbRoute" {
  zone_id = aws_route53_zone.privateRoute.zone_id
  name    = "lb.projetoaws.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.loadBalancer[0].dns_name]
}