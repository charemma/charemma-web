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

### Initial setup

Prerequisites: k3s is running on the VPS, kubectl is configured locally.

1. The container image must exist on ghcr.io. This happens automatically on the
   first push to main (GitHub Actions). The package must be public on ghcr.io,
   otherwise k3s needs an imagePullSecret.

2. Apply the manifests:
   ```
   kubectl apply -f k8s/
   ```

3. Verify everything is running:
   ```
   kubectl get pods
   kubectl get ingress
   ```

### Updates

Every push to main builds a new image via GitHub Actions. To make the pod pull
the latest image:

```
kubectl rollout restart deployment charemma-web
```

Or from the nixos-config repo:

```
just deploy-web
```
