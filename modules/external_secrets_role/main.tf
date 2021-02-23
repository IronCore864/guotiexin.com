data "aws_caller_identity" "current" {}

data "template_file" "trust_json_for_alb" {
  template = file("${path.module}/templates/trust.json.tpl")

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    oidc_provider  = trimprefix(var.oidc_provider, "https://")

    sa_namespace = "kube-system"
    sa           = "external-secrets-kubernetes-external-secrets"
  }
}

resource "aws_iam_policy" "external_secrets_policy" {
  name        = "external-secrets-role-policy"
  description = "External secrets policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "external_secrets_role" {
  name               = "external-secrets-role"
  assume_role_policy = data.template_file.trust_json_for_alb.rendered
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = aws_iam_role.external_secrets_role.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}
