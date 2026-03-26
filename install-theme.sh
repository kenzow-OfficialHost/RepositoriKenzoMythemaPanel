#!/bin/bash
set -e

# Path repo
REPO_DIR="$(pwd)"
THEME_SRC="$REPO_DIR/theme"
THEME_DEST="/var/www/pterodactyl/resources/theme"
BLADE_FILE="/var/www/pterodactyl/resources/views/layouts/admin.blade.php"

# 1. Hapus theme lama
if [ -d "$THEME_DEST" ]; then
    echo "⚠️ Menghapus theme lama..."
    rm -rf "$THEME_DEST"
fi

# 2. Copy theme baru
echo "📁 Menyalin theme baru..."
cp -r "$THEME_SRC" "$THEME_DEST"
chown -R www-data:www-data "$THEME_DEST"
chmod -R 755 "$THEME_DEST"

# 3. Update admin.blade.php
echo "📝 Mengupdate admin.blade.php..."
cat > "$BLADE_FILE" <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{{ config('app.name', 'Pterodactyl') }}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="_token" content="{{ csrf_token() }}">

    <!-- Theme CSS & JS -->
    <link rel="stylesheet" href="{{ asset('theme/css/panel.css') }}">
    <script src="{{ asset('theme/js/panel.js') }}"></script>

    <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon.png">
    <link rel="icon" type="image/png" href="/favicons/favicon-32x32.png">
    <link rel="manifest" href="/favicons/site.webmanifest">
    <link rel="mask-icon" href="/favicons/safari-pinned-tab.svg" color="#5bbad5">
    <link rel="shortcut icon" href="/favicons/favicon.ico">
    <meta name="msapplication-config" content="/favicons/browserconfig.xml">
    <meta name="theme-color" content="#0e46b2">

    @include('layouts.scripts')
</head>
<body>
EOF

# 4. Clear Laravel cache
echo "🧹 Membersihkan cache Laravel..."
cd /var/www/pterodactyl
php artisan view:clear
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan optimize:clear

echo "✅ Theme dan Blade berhasil di-install!"
