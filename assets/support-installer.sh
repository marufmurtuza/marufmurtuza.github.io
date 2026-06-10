#!/bin/bash

set -e

URL="https://github.com/rustdesk/rustdesk/releases/download/1.4.7/rustdesk-1.4.7-armv7-sciter.deb"
FILE="rustdesk.deb"

USER_NAME="$(whoami)"

echo "[*] Downloading RustDesk..."
wget -O "$FILE" "$URL"

echo "[*] Installing dependencies..."
echo "$USER_NAME" | sudo -S apt install -y libxdo3 gstreamer1.0-pipewire

echo "[*] Fixing broken packages..."
echo "$USER_NAME" | sudo -S apt --fix-broken install -y

echo "[*] Installing RustDesk package..."
echo "$USER_NAME" | sudo -S dpkg -i "$FILE" || true

echo "[*] Fixing any missing dependencies..."
echo "$USER_NAME" | sudo -S apt --fix-broken install -y

echo "[*] Launching RustDesk..."
nohup rustdesk >/dev/null 2>&1 &

sleep 20

echo "[*] Setting RustDesk password..."
rustdesk --password HGMQ60ST

sleep 20

rm -rf "$FILE"

echo "[*] Getting RustDesk ID..."
RUSTDESK_ID=$(rustdesk --get-id 2>/dev/null || true)

echo "================================"
echo "RustDesk ID: $RUSTDESK_ID"
echo "Password: HGMQ60ST"
echo "================================"

echo "[+] Done."
