#!/bin/bash
set -e

echo "Deployment started ..."

# Enter maintenance mode or return true if already in maintenance mode
(php artisan down) || true 

# Check for local changes and stash them if necessary
if ! git diff-index --quiet HEAD --; then
    echo "Stashing local changes..."
    git stash
fi

# Pull the latest version of the app
echo "Pulling the latest changes from the repository..."
git pull origin main

# Install composer dependencies
echo "Installing composer dependencies..."
composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Clear the old cache
echo "Clearing the old cache..."
php artisan clear-compiled

# Recreate cache
echo "Recreating the cache..."
php artisan optimize

# Compile npm assets
# Uncomment the following line if npm assets are required
# echo "Compiling npm assets..."
# npm run prod

# Run database migrations
# Uncomment the following line if migrations are required
# echo "Running database migrations..."
# php artisan migrate --force

# Exit maintenance mode
echo "Exiting maintenance mode..."
php artisan up

echo "Deployment finished!"
