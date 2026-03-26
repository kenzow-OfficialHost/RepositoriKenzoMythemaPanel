#!/bin/bash
# Installer Theme Pterodactyl Panel (Ubuntu 16–24)
PANEL_ROOT="/var/www/pterodactyl"
THEME_SOURCE="theme"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Run as root!"
  exit 1
fi

cd "$PANEL_ROOT" || { echo "❌ Panel not found!"; exit 1; }

# Install Node.js if missing
if ! command -v node >/dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
fi

# Backup resources
cp -r resources resources_backup_$(date +%s)

# Clean dependencies
rm -rf node_modules package-lock.json yarn.lock
npm cache clean --force

# Install & build
npm install --legacy-peer-deps
npm run build

# Copy theme
cp -r "$THEME_SOURCE/." "$PANEL_ROOT/resources/"

# Clear cache & fix permission
php artisan optimize:clear
chown -R www-data:www-data "$PANEL_ROOT"
chmod -R 755 "$PANEL_ROOT"

echo "✅ Theme installed successfully!"
