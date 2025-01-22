#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Puppeteer globally
# npm install puppeteer
# npm install puppeteer-core

# Install Chromium (used by Puppeteer)
npx puppeteer browsers install chrome

# Echo to verify if Puppeteer is installed and Chrome is available
# echo "Puppeteer installed and Chrome is being fetched..."
rm -rf package-lock.json node_modules
npm install
npm list

# Store/pull Puppeteer cache with build cache
if [[ ! -d $PUPPETEER_CACHE_DIR ]]; then 
  echo "...Copying Puppeteer Cache from Build Cache" 
  cp -R $XDG_CACHE_HOME/puppeteer/ $PUPPETEER_CACHE_DIR || { echo "Failed to copy Puppeteer cache"; exit 1; }
else 
  echo "...Storing Puppeteer Cache in Build Cache" 
  cp -R $PUPPETEER_CACHE_DIR $XDG_CACHE_HOME || { echo "Failed to store Puppeteer cache"; exit 1; }
fi

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

bundle exec rails db:migrate