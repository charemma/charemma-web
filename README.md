# charemma-web

Static portfolio website for [charemma.de](https://charemma.de).

Deployed via [nixos-config](https://github.com/charemma/nixos-config) as a flake
input -- Caddy serves the static files directly from the nix store.

## Local dev

```
just dev       # local server on http://localhost:8080
```

## Deploying changes

Push to main, then from nixos-config:

```
nix flake update charemma-web
just deploy-vps
```
