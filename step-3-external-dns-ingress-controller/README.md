In this step, we first setup the IAM roles to be used by external-dns and AWS load balancer controller using Terraform, then we install them.

## IAM Roles

```
cd terraform
terraform apply -target=module.load-balancer-controller-role
terraform apply -target=module.external-dns-role
```

## External DNS

Update the IAM role values accordingly in the values file before applying:

```
helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -f load-balancer-controller-values.yaml
```

## Load Balancer Controller

```
helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -f load-balancer-controller-values.yaml
```
