# Linkerd Multi-Cluster Mesh

## Setup

### 0. Tools

Install the tool `step` which is used to generate certificates:

```bash
brew install step
```

### 1. Generate Certificates

Using `step` to generate root ca and issuer cert:

```bash
step certificate create root.linkerd.cluster.local root.crt root.key \
  --profile root-ca --no-password --insecure --not-after=87600h

step certificate create identity.linkerd.cluster.local issuer.crt issuer.key \
  --profile intermediate-ca --not-after 8760h --no-password --insecure \
  --ca root.crt --ca-key root.key
```

### 2. Control Plane Install

Install Linkerd control plane to two clusters, assuming one context is called `tiexin` and the other `tiexin2`:

```bash
linkerd install \
  --identity-trust-anchors-file root.crt \
  --identity-issuer-certificate-file issuer.crt \
  --identity-issuer-key-file issuer.key \
  | tee \
    >(kubectl --context=tiexin apply -f -) \
    >(kubectl --context=tiexin2 apply -f -)
```

Optional: check control plane install :

```bash
for ctx in tiexin tiexin2; do
  echo "Checking cluster: ${ctx} .........\n"
  linkerd --context=${ctx} check || break
  echo "-------------\n"
done
```

### 3. Multi-Cluster Components Install (gateway)

Install Linkerd multi-cluster component(gateway) in two clusters. In essence, it installs an Nginx, with service type load balancer:

```bash
for ctx in tiexin tiexin2; do
  echo "Installing on cluster: ${ctx} ........."
  linkerd --context=${ctx} multicluster install | \
    kubectl --context=${ctx} apply -f - || break
  echo "-------------\n"
done
```

*NOTE for private clusters:* if both your clusters are in the same VPC and subnets and can talk to each other and you don't want the linkerd gateway traffic to go through public internet, you can change the load balancer to internal, by editing `svc/linkerd-gateway` in `linkerd-multicluster` namespace and adding an annotation: `service.beta.kubernetes.ioaws-load-balancer-internal: "true"`.

Optional: to verify the install:

```bash
for ctx in tiexin tiexin2; do
  echo "Checking gateway on cluster: ${ctx} ........."
  kubectl --context=${ctx} -n linkerd-multicluster \
    rollout status deploy/linkerd-gateway || break
  echo "-------------\n"
done

for ctx in tiexin tiexin2; do
  printf "Checking cluster: ${ctx} ........."
  while [ "$(kubectl --context=${ctx} -n linkerd-multicluster get service -o 'custom-columns=:.status.loadBalancer.ingress[0].hostname' --no-headers)" = "<none>" ]; do
      printf '.'
      sleep 1
  done
  printf "\n"
done
```

### 4. Linking the Clusters

To link cluster `tiexin2` to `tiexin`:

```bash
linkerd --context=tiexin2 multicluster link --cluster-name tiexin2 |
  kubectl --context=tiexin apply -f -
```

Optional: check the linking:

```bash
linkerd --context=tiexin check --multicluster

# Additionally, the `tiexin2` gateway should now show up in the `tiexin` cluster gateway list:
linkerd --context=tiexin multicluster gateways
```

## Test

### Service Mirroring

Create a service in cluster `tiexin2`, for example with name `helloworld`, then in cluster `tiexin`, a mirror service named `helloworld-tiexin2` (servicename-contextname) will be created automatically.

This can be used from inside the mesh by directly referring to the service name `http://helloworld-tiexin2`.

### % Traffic Split / Canary in Two Clusters

You can also use it together with traffic split, for example:

- deploy service `helloworld` v1 in cluster `tiexin`
- deploy service `helloworld` v2 in cluster `tiexin2`

Then use the following traffic split:

```yaml
apiVersion: split.smi-spec.io/v1alpha1
kind: TrafficSplit
metadata:
  name: helloworld
  namespace: default
spec:
  service: helloworld
  backends:
  - service: helloworld
    weight: 50
  - service: helloworld-tiexin2
    weight: 50
```

This demo can be found in [this repo](https://github.com/IronCore864/gitops-argocd/tree/master/argo-apps) using ArgoCD:

- Application `helloworld` deploys v2 to cluster `tiexin`, with traffic split, and a load generator, but with the service unexported.
- Application `helloworld-tiexin2` deploys v1 to cluster `tiexin2`, without traffic split or a load generator but service exported so that it can be mirrored in cluster `tiexin`.


## More Details

See https://linkerd.io/2/tasks/multicluster/.
