#!/usr/bin/env bash

# update.sh v1.0.0

# Coloured output
info() { echo -e "\e[32m[INFO]\e[0m $*"; }

# Get latest version 
get_latest_version() {
    curl -s "$1" | \
    grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
    sort -V | \
    tail -n 1
}

# Get nix hash 
get_nix_hash() {
    local url=$1
    local hash=$(nix-prefetch-url --type sha256 "$url")
    nix hash to-sri --type sha256 "$hash"
}

# 1. Update Opera Stable
info "Checking for Opera Stable..."
OPERA_VERSION=$(get_latest_version "https://download3.operacdn.com/ftp/pub/opera/desktop/")
OPERA_URL="https://download3.operacdn.com/ftp/pub/opera/desktop/${OPERA_VERSION}/linux/opera-stable_${OPERA_VERSION}_amd64.deb"

info "Opera Stable latest version: $OPERA_VERSION"
OPERA_HASH=$(get_nix_hash "$OPERA_URL")

sed -i "s/version = \".*\";/version = \"$OPERA_VERSION\";/" one.nix
sed -i "s|hash = \".*\";|hash = \"$OPERA_HASH\";|" one.nix
info "one.nix updated!"

# 1. Update Opera GX
info "Checking for Opera GX..."
GX_VERSION=$(get_latest_version "https://download3.operacdn.com/ftp/pub/opera_gx/")
GX_URL="https://download3.operacdn.com/ftp/pub/opera_gx/${GX_VERSION}/linux/opera-gx-stable_${GX_VERSION}_amd64.deb"

info "Opera GX latest version: $GX_VERSION"
GX_HASH=$(get_nix_hash "$GX_URL")

sed -i "s/version = \".*\";/version = \"$GX_VERSION\";/" gx.nix
sed -i "s|hash = \".*\";|hash = \"$GX_HASH\";|" gx.nix
info "gx.nix updated!"

info "All updates checked!"