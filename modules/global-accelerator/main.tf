resource "aws_globalaccelerator_accelerator" "main" {
  name            = "main"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "main" {
  accelerator_arn = aws_globalaccelerator_accelerator.main.id
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "main" {
  listener_arn = aws_globalaccelerator_listener.main.id

  endpoint_configuration {
    endpoint_id = var.alb_arn
    weight      = 128
  }
}
