default:
    @just --list

# Local dev server on http://localhost:8080
dev:
    python3 -m http.server 8080 --directory html
