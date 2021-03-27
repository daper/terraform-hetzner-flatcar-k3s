This is a terraform module that deploys a k3s cluster on hetzner by using flatcar as the OS for the underlying machines.

### Requirements
- **hcloud** command must be installed and configured previously.
- **kubectl** command must be installed.

Configure your environment with HCLOUD_TOKEN var to access hetzner's API.

Configure AWS account to access Route53 API. And set up properly *tfvars* file or env vars for:
- aws_access_token
- aws_secret_key
- hcloud_token

```sh
terraform apply -var-file variables.tfvars
```

This example can be used to test the configuration is working:
```sh
kubectl --kubeconfig modules/k3s/kube-config.yaml apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: default
spec:
  type: ClusterIP
  ports:
  - port: 80
    name: http
    targetPort: 80
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
          name: http
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: default
  annotations:
    kubernetes.io/ingress.class: traefik
    external-dns.alpha.kubernetes.io/hostname: nginx.k8s.daper.io
spec:
  rules:
  - host: nginx.k8s.daper.io
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx
            port:
              number: 80
EOF
```