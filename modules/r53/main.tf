resource "aws_route53_zone" "primary" {
  name = var.zone_name
}

resource "aws_route53_record" "cv" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "cv.${var.zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["ironcore864.github.io"]
}
