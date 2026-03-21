# charemma-web

Portfolio website: [charemma.de](https://charemma.de)

Static site, served as nginx container on k3s. Pushes to main automatically
build a new image via GitHub Actions and push it to ghcr.io.

## Local dev

```
just dev
```

Starts a Python HTTP server on http://localhost:8080.

## Deployment

The website runs on a VPS with k3s (Traefik ingress + Let's Encrypt).
The NixOS config for the VPS lives in [nixos-config](https://github.com/charemma/nixos-config).

Deployment is fully managed via GitOps using ArgoCD. The ArgoCD Application
is defined in [nixos-config/infra/vps/apps/charemma-web.yaml](https://github.com/charemma/nixos-config/blob/main/infra/vps/apps/charemma-web.yaml)
and points at the `k8s/` directory in this repo.

### How it works

1. Push to main triggers GitHub Actions
2. Actions builds and pushes the container image to ghcr.io
3. Actions commits the new image SHA tag back to `k8s/deployment.yaml`
4. ArgoCD detects the manifest change and syncs the deployment automatically

No manual `kubectl` commands needed.
