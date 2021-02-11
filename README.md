# Infrastructure as Code for guotiexin.com

This is the infrastructure as code part for the website [guotiexin.com](https://www.guotiexin.com), which is yet another website simply powered by WordPress.

(There is another host on my website that is [argocd.guotiexin.com](https://argocd.guotiexin.com) which is my GitOps CD system.)

It's not simple though:

### Network Infrastructure

Single VPC with multi-AZ for HA.

There isn't multi-region setup though because I don’t believe in business continuity in the case of regional warfare.

### Database

Amazon Aurora RDS for MySQL cluster with a multi-AZ setup.

The read endpoint of Aurora isn’t used yet, because the helm chart I used to install WordPress doesn’t support separating wp-admin to write endpoint and others to read endpoint, which I think I will try to improve in the future.

For the same reason mentioned above, there isn’t a cross-region Aurora snapshot setup.

### State-of-the-Art Infrastructure

Everything running in the Kubernetes.

DNS is automatically managed by external-dns in Route53.

Latest AWS load balancer controller as ingress controller. If you don't know how to use it yet, see my [medium post here](https://medium.com/devops-dudes/running-the-latest-aws-load-balancer-controller-in-your-aws-eks-cluster-9d59cdc1db98).

AWS Certificate Manager for SSL certs management.

Secrets are managed by AWS Secrets Manager. No secret is stored in any git repo during the construction of this website.

CloudFront as CDN, ELB origin to ALB, then to K8s ingress.

### SLA

None provided.

The wordpress is a single pod which I know is a single point of failure but don't laugh, because it is by design.

I don't want to use horizontal pod autoscaling or node autoscaler, not because I don't know how, but because I want to minimize financial and operational cost.

Also, because I don’t care about the downtime since it’s merely a blog.

### Infrastructure as Code

Done by Terraform with reusable modules with detailed READMEs.

I separated the infrastructure into multiple steps because I want to clearly document how is everything created. In the real world, it can be done via one pipeline.

You can probably do better than this for a WordPress blog, but probably by not much.
