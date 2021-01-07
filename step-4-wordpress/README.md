In this step, we install wordpress and ingress:

## WordPress

```
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install wordpress bitnami/wordpress -f wordpress-values.yaml \
  --set mariadb.enabled=false \
  --set externalDatabase.host=<put_your_db_write_endpoint_here> \
  --set externalDatabase.user=<put_your_db_user_here> \
  --set externalDatabase.password=<put_your_db_password_here> \
  --set externalDatabase.database=wordpress \
  --set externalDatabase.port=3306
```

Here we use service type ClusterIP because we want to use ALB later for ingress instead of ELB, or the ingress from the helm chart which isn't flexible enough.

If you need to upgrade the helm chart:

```
helm upgrade wordpress bitnami/wordpress -f wordpress-values.yaml \
  --set mariadb.enabled=false \
  --set externalDatabase.host=<put_your_db_write_endpoint_here> \
  --set externalDatabase.user=<put_your_db_user_here> \
  --set externalDatabase.password=<put_your_db_password_here> \
  --set externalDatabase.database=wordpress \
  --set externalDatabase.port=3306 \
  --set wordpressPassword=<put_your_wordpress_pwd_here>
```

## Ingress

We want to achieve the following for the ALB:

- Listens on 443 only
- Hostname supports both apex domain and www
- No access by default, only allowing CloudFront access with a certain header

Replace the values first, then:

```
kubectl apply -f wordpress-ingress.yaml
```

## Global Accelerator

After ALB is created, we can then create the global accelerator for it:

```
cd terraform
terraform apply -target=module.global-accelerator
```
