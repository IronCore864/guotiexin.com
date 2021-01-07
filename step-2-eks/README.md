In this step, we setup the EKS cluster using eksctl.

## Create Cluster

```bash
eksctl create cluster -f cluster.yaml
```

## Grant AWS Console User Access to the Cluster

Edit configmap aws-auth to allow AWS console role to access the EKS (in case you did not create the cluster with the console user access key) by adding the following section:

```
- groups:
  - system:masters
  rolearn: arn:aws:iam::391996659322:role/Admin-OneClick
```

## Create IAM OIDC Provider

```
eksctl utils associate-iam-oidc-provider \
    --region eu-central-1 \
    --cluster tiexin \
    --approve
```
