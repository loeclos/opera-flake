#!/usr/bin/env bash

# update.sh v1.0.1

# Coloured output
info() { echo -e "\e[32m[INFO]\e[0m $*"; }
warn() { echo -e "\e[33m[WARN]\e[0m $*"; }

# Get latest version 
get_all_versions() {
    curl -s "$1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -V -r
}

# Get nix hash 
get_nix_hash() {
    local url=$1
    local hash=$(nix-prefetch-url --type sha256 "$url")
    nix hash to-sri --type sha256 "$hash"
}

# --- Update Opera Stable ---
info "Checking for Opera Stable..."
STABLE_BASE="https://download3.operacdn.com/ftp/pub/opera/desktop/"
# Fetch versions
STABLE_VERSIONS=$(get_all_versions "$STABLE_BASE")

for OPERA_VERSION in $STABLE_VERSIONS; do
    OPERA_URL="${STABLE_BASE}${OPERA_VERSION}/linux/opera-stable_${OPERA_VERSION}_amd64.deb"
    
    # Check link
    STATUS=$(curl -Is "$OPERA_URL" | head -n 1 | cut -d' ' -f2 | tr -d '\r')
    
    if [ "$STATUS" = "200" ]; then
        info "Found valid Opera Stable version: $OPERA_VERSION"
        OPERA_HASH=$(get_nix_hash "$OPERA_URL")
        sed -i "s/version = \".*\";/version = \"$OPERA_VERSION\";/" one.nix
        sed -i "s|hash = \".*\";|hash = \"$OPERA_HASH\";|" one.nix
        info "one.nix updated!"
        break
    elif [ "$STATUS" = "404" ]; then
        warn "Version $OPERA_VERSION is 404 on Linux, trying previous..."
        continue
    fi
done

# --- Update Opera GX ---
info "Checking for Opera GX..."
GX_BASE="https://download3.operacdn.com/ftp/pub/opera_gx/"
GX_VERSIONS=$(get_all_versions "$GX_BASE")

for GX_VERSION in $GX_VERSIONS; do
    GX_URL="${GX_BASE}${GX_VERSION}/linux/opera-gx-stable_${GX_VERSION}_amd64.deb"
    
    STATUS=$(curl -Is "$GX_URL" | head -n 1 | cut -d' ' -f2 | tr -d '\r')
    
    if [ "$STATUS" = "200" ]; then
        info "Found valid Opera GX version: $GX_VERSION"
        GX_HASH=$(get_nix_hash "$GX_URL")
        sed -i "s/version = \".*\";/version = \"$GX_VERSION\";/" gx.nix
        sed -i "s|hash = \".*\";|hash = \"$GX_HASH\";|" gx.nix
        info "gx.nix updated!"
        break
    elif [ "$STATUS" = "404" ]; then
        warn "Version $GX_VERSION is 404 on Linux, trying previous..."
        continue
    fi
done

info "All updates checked!"