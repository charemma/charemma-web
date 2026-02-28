# charemma.de Deployment
# Konfiguration anpassen:
VPS_HOST := "charemma.de"
VPS_USER := "charemma"
VPS_PATH := "/home/charemma/charemma-web"

default:
    @just --list

# Lokaler Dev-Server (Caddy file server)
dev:
    docker run --rm -p 8080:80 -v {{justfile_directory()}}/html:/var/www/html:ro docker.io/library/caddy:alpine caddy file-server --root /var/www/html --listen :80

# Deployment auf VPS
deploy:
    #!/usr/bin/env bash
    set -e
    echo "Deploying to {{VPS_USER}}@{{VPS_HOST}}:{{VPS_PATH}}"

    # Sync files (nur was noetig ist)
    rsync -avz --delete \
        --exclude '.git' \
        --exclude '.DS_Store' \
        --exclude 'etc' \
        --exclude 'etc.orig' \
        --exclude 'Dockerfile' \
        {{justfile_directory()}}/ {{VPS_USER}}@{{VPS_HOST}}:{{VPS_PATH}}/

    # Container neu starten
    ssh {{VPS_USER}}@{{VPS_HOST}} "docker stop caddy 2>/dev/null || true; docker rm caddy 2>/dev/null || true; docker run -d --name caddy --restart always -p 80:80 -p 443:443 -v {{VPS_PATH}}/Caddyfile:/etc/caddy/Caddyfile:ro -v {{VPS_PATH}}/html:/var/www/html:ro -v caddy_data:/data -v caddy_config:/config caddy:alpine"

    echo "Done! https://charemma.de"

# Nur Dateien syncen (ohne Container Restart)
sync:
    rsync -avz --delete \
        --exclude '.git' \
        --exclude '.DS_Store' \
        --exclude 'etc' \
        --exclude 'etc.orig' \
        --exclude 'Dockerfile' \
        {{justfile_directory()}}/ {{VPS_USER}}@{{VPS_HOST}}:{{VPS_PATH}}/

# Container Logs anzeigen
logs:
    ssh {{VPS_USER}}@{{VPS_HOST}} "docker logs -f caddy"

# Container Status
status:
    ssh {{VPS_USER}}@{{VPS_HOST}} "docker ps -f name=caddy"

# Container stoppen
stop:
    ssh {{VPS_USER}}@{{VPS_HOST}} "docker stop caddy"

# Container neustarten
restart:
    ssh {{VPS_USER}}@{{VPS_HOST}} "docker restart caddy"
