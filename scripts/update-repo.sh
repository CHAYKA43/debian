#!/bin/bash
set -e

REPO_DIR="$(dirname "$(realpath "$0")")/.."
DIST_DIR="$REPO_DIR/dists/stable"
ARCH="amd64"
COMPONENT="main"
POOL_DIR="$REPO_DIR/pool/$COMPONENT"
PKG_DIR="$DIST_DIR/$COMPONENT/binary-$ARCH"

mkdir -p "$PKG_DIR"
mkdir -p "$POOL_DIR"

echo "🛠 Обновляю Packages..."
cd "$POOL_DIR"
dpkg-scanpackages . /dev/null | sed "s|^Filename: ./|Filename: pool/$COMPONENT/|" > "$PKG_DIR/Packages"
gzip -k -f "$PKG_DIR/Packages"

echo "🛠 Обновляю Release..."
cat > "$DIST_DIR/Release" <<EOF
Origin: Chayka43
Label: Chayka43
Suite: stable
Codename: stable
Architectures: $ARCH
Components: $COMPONENT
Description: Custom APT repo on GitHub Pages
EOF

cd "$DIST_DIR"
apt-ftparchive release . >> Release

echo "🔏 Подписываю Release..."
gpg --batch --yes --pinentry-mode loopback --passphrase "$GPG_PASSPHRASE" --armor --detach-sign --output "$DIST_DIR/Release.gpg" "$DIST_DIR/Release"
