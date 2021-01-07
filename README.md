# Infrastructure as Code for guotiexin.com

This is the infrastructure as code part for the website [guotiexin.com](https://www.guotiexin.com), which is yet another website simply powered by WordPress.

It's not simple though:

- The setup is production-ready
- in a kubernetes cluster running inside AWS EKS
- in a single region VPC with multi-AZ setup. I don’t believe in business continuity in the case of regional warfare.
- Only 1 pod is running as a single point of failure. Don't laugh; it is by design. No horizontal pod autoscaling because I want to maximize operational cost and financial cost. Also, because I don’t care about the downtime since it’s merely a blog. **Note: no SLA is provided.**
- The data, however, is safely and redundantly stored in an Amazon Aurora RDS for MySQL cluster with a multi-AZ setup. Although I can live with the website going down, I don’t want to lose my articles. The read endpoint of Aurora isn’t used yet, because the helm chart I used to install WordPress doesn’t support separating wp-admin to write endpoint and others to read endpoint, which I think I will try to improve in the future. For the same reason mentioned above, there isn’t a cross-region Aurora snapshot setup.
- DNS is managed by route 53 and automatically by external-dns.
- For ingress we use the latest AWS load balancer controller. If you don't know how to use it yet, see my [medium post here](https://medium.com/devops-dudes/running-the-latest-aws-load-balancer-controller-in-your-aws-eks-cluster-9d59cdc1db98).
- SSL certs are managed by AWS Certificate Manager.
- Both CloudFront and global accelerator are used.
- Done by Terraform with reusable modules and detailed READMEs, with secrets fetched from AWS Secrets Manager. No secret is stored in any git repo during the construction of this website.

You can probably do better than this for a WordPress blog, but probably by not much.
