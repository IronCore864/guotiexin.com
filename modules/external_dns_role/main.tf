data "aws_caller_identity" "current" {}

data "template_file" "trust_json_for_alb" {
  template = file("${path.module}/templates/trust.json.tpl")

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    oidc_provider  = trimprefix(var.oidc_provider, "https://")

    sa_namespace = "kube-system"
    sa           = "external-dns"
  }
}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "external-dns-role-policy"
  description = "External DNS policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "external_dns_role" {
  name               = "external-dns-role"
  assume_role_policy = data.template_file.trust_json_for_alb.rendered
}

resource "aws_iam_role_policy_attachment" "alb" {
  role       = aws_iam_role.external_dns_role.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}
