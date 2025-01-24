#!/usr/bin/env bash
# exit on error
set -o errexit

rm -rf package-lock.json node_modules
npm install
npm list

export PUPPETEER_CACHE_DIR=${PUPPETEER_CACHE_DIR:-$XDG_CACHE_HOME/puppeteer}

# Log the cache path
echo "Puppeteer Cache Directory: $PUPPETEER_CACHE_DIR"

# Install Chromium (used by Puppeteer)
export PUPPETEER_CHROME_REVISION=131.0.6778.87

# Install Chromium (used by Puppeteer)
npx @puppeteer/browsers install chrome@131.0.6778.87

# Check if Chrome is installed
CHROME_PATH="$PUPPETEER_CACHE_DIR/chrome/linux-$PUPPETEER_CHROME_REVISION/chrome-linux64/chrome"
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


CHROME_VERSION=$("/opt/render/.cache/puppeteer/chrome/linux-131.0.6778.204/chrome-linux64/chrome" --version)
echo "Installed Chrome version: $CHROME_VERSION"


bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

bundle exec rails db:migrate

echo "Checking for Chrome executable at: /opt/render/.cache/puppeteer/chrome/linux-131.0.6778.204/chrome-linux64/"
ls -l /opt/render/.cache/puppeteer/chrome/linux-131.0.6778.204/chrome-linux64/

chmod +x /opt/render/.cache/puppeteer/chrome/linux-131.0.6778.204/chrome-linux64/chrome