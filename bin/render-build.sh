#!/usr/bin/env bash
# exit on error
set -o errexit
export PUPPETEER_CACHE_DIR=${PUPPETEER_CACHE_DIR:-$XDG_CACHE_HOME/puppeteer}

npm install

# Install Chromium (used by Puppeteer)
npx puppeteer browsers install chrome || { echo "Failed to install Chrome"; exit 1; }


# Log the cache path
echo "Puppeteer Cache Directory: $PUPPETEER_CACHE_DIR"

# Store/pull Puppeteer cache with build cache
# if [[ ! -d $PUPPETEER_CACHE_DIR ]]; then 
#   echo "...Copying Puppeteer Cache from Build Cache" 
#   cp -R $XDG_CACHE_HOME/puppeteer/ $PUPPETEER_CACHE_DIR || { echo "Failed to copy Puppeteer cache"; exit 1; }
# else 
#   echo "...Storing Puppeteer Cache in Build Cache" 
#   if [[ "$PUPPETEER_CACHE_DIR" != "$XDG_CACHE_HOME" ]]; then
#     cp -R $PUPPETEER_CACHE_DIR $XDG_CACHE_HOME || { echo "Failed to store Puppeteer cache"; exit 1; }
#   else
#     echo "Source and destination are the same. Skipping copy."
#   fi
# fi

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

bundle exec rails db:migrate