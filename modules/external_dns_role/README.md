# External DNS IAM Role

Create an IAM role to be used for external-dns inside EKS, which in turn uses IAM role for service account and OIDC connector.

For more detials, see:

- https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
- https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
- https://github.com/kubernetes-sigs/external-dns

Note that this module only creates the IAM role to be used; it doesn't create the external-dns itself.
