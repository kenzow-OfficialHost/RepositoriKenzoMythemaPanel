#!/bin/bash
set -e

REPO_DIR="$(pwd)"
THEME_SRC="$REPO_DIR/theme"
THEME_DEST="/var/www/pterodactyl/resources/theme"

if [ ! -d "$THEME_SRC" ]; then
    echo "ERROR: Folder theme tidak ditemukan di $THEME_SRC"
    exit 1
fi

if [ -d "$THEME_DEST" ]; then
    mv "$THEME_DEST" "${THEME_DEST}_backup_$(date +%F_%H%M%S)"
fi

cp -r "$THEME_SRC" "$THEME_DEST"

chown -R www-data:www-data "$THEME_DEST"
chmod -R 755 "$THEME_DEST"

cd /var/www/pterodactyl
php artisan view:clear
php artisan cache:clear
php artisan config:clear

echo "✅ Theme installed successfully!"
