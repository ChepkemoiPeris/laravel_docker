#!/bin/bash
set -e

echo "Deployment started ..."

# Enter maintenance mode or return true
# if already is in maintenance mode
(php artisan down) || true

# Pull the latest version of the app 
# Discard any local changes to avoid conflicts
git fetch origin main
git reset --hard origin/main

# Pull the latest changes
git pull origin main

# Ensure the deploy script has executable permissions
chmod +x ./.scripts/deploy.sh

# Install composer dependencies
composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Clear the old cache
php artisan clear-compiled

# Recreate cache
php artisan optimize

# Compile npm assets
# npm run prod

# Run database migrations
# php artisan migrate --force

# Exit maintenance mode
php artisan up

echo "Deployment finished!"