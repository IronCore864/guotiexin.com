# AWS Load Balancer Controller IAM Role

Create an IAM role to be used for AWS load balancer controller, which in turn uses IAM role for service account and OIDC connector.

For more detials, see:

- https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
- https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
- https://aws.amazon.com/about-aws/whats-new/2020/10/introducing-aws-load-balancer-controller/
- https://github.com/kubernetes-sigs/aws-load-balancer-controller
- https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/

Note that this module only creates the IAM role to be used; it doesn't create the AWS load balancer controller itself.
