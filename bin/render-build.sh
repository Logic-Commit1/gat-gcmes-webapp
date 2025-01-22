#!/usr/bin/env bash
# exit on error
set -o errexit
export PUPPETEER_CACHE_DIR=${PUPPETEER_CACHE_DIR:-$XDG_CACHE_HOME/puppeteer}

# Log the cache path
echo "Puppeteer Cache Directory: $PUPPETEER_CACHE_DIR"

# Install Chromium (used by Puppeteer)
npx puppeteer browsers install chrome || { echo "Failed to install Chrome"; exit 1; }

# Check if Chrome is installed
CHROME_PATH="$PUPPETEER_CACHE_DIR/chrome/linux-131.0.6778.87/chrome-linux64/chrome"
if [[ -f "$CHROME_PATH" ]]; then
  echo "Chrome has been successfully installed at: $CHROME_PATH"
  
  # Check permissions
  if [[ -x "$CHROME_PATH" ]]; then
    echo "Chrome executable has the correct permissions."
  else
    echo "Chrome executable does not have execute permissions. Attempting to set permissions."
    chmod +x "$CHROME_PATH" || { echo "Failed to set permissions on Chrome executable"; exit 1; }
  fi
else
  echo "Chrome installation failed or Chrome not found at: $CHROME_PATH"
  exit 1
fi

CHROME_VERSION=$("$CHROME_PATH" --version)
echo "Installed Chrome version: $CHROME_VERSION"

# Echo to verify if Puppeteer is installed and Chrome is available
rm -rf package-lock.json node_modules
npm install
npm list

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