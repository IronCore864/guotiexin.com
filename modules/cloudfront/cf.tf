data "aws_secretsmanager_secret_version" "origin_custom_header" {
  secret_id = "prod/wordpress/origin_custom_header"
}

locals {
  origin_custom_header = jsondecode(
    data.aws_secretsmanager_secret_version.origin_custom_header.secret_string
  )
}


resource "aws_cloudfront_distribution" "alb_distribution" {
  origin {
    origin_id   = "elb_origin"
    domain_name = var.origin_domain_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "X-Custom-Header"
      value = local.origin_custom_header.value
    }
  }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = ""

  aliases = ["guotiexin.com", "www.guotiexin.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "elb_origin"

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"
  web_acl_id  = var.web_acl_id

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:391996659322:certificate/5647cb8c-74c5-4635-a069-7823b322edd5"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
