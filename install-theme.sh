#!/bin/bash
set -e

# Path repo
REPO_DIR="$(pwd)"
THEME_SRC="$REPO_DIR/theme"
THEME_DEST="/var/www/pterodactyl/resources/theme"

# Cek folder theme
if [ ! -d "$THEME_SRC" ]; then
    echo "ERROR: Folder theme tidak ditemukan di $THEME_SRC"
    exit 1
fi

# Backup resources lama jika ada
if [ -d "$THEME_DEST" ]; then
    mv "$THEME_DEST" "${THEME_DEST}_backup_$(date +%F_%H%M%S)"
fi

# Copy theme
cp -r "$THEME_SRC" "$THEME_DEST"

# Fix permission
chown -R www-data:www-data "$THEME_DEST"
chmod -R 755 "$THEME_DEST"

# Clear Laravel cache
cd /var/www/pterodactyl
php artisan view:clear
php artisan cache:clear
php artisan config:clear

echo "✅ Theme installed successfully!"
