Last step, we create the CF distribution:

## CloudFront

```
cd terraform
terraform apply -target=module.wordpress-cf
```

After CF distribution is created, create an R53 record for the www host and set it as an alias to the CF distribution; then create another R53 record for the apex domain and set it as an alias to the www record.
