#!/bin/bash
cd /var/www/pterodactyl || exit 1
echo "[INFO] Cleaning old node_modules..."
rm -rf node_modules package-lock.json yarn.lock
npm cache clean --force
echo "[INFO] Installing dependencies..."
npm install --legacy-peer-deps
echo "[INFO] Build assets..."
npm run build
echo "[INFO] Done."
