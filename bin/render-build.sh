#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Puppeteer globally
npm install puppeteer --global

# Install Chromium (used by Puppeteer)
npx puppeteer browsers install chrome

# Echo to verify if Puppeteer is installed and Chrome is available
echo "Puppeteer installed and Chrome is being fetched..."

# Check if the Chrome executable is available in Puppeteer's installed path
CHROME_PATH="/opt/render/.cache/puppeteer/chrome/linux-131.0.6778.87/chrome-linux64/chrome"
if [ -f "$CHROME_PATH" ]; then
    echo "Chrome installed at $CHROME_PATH"
    export PUPPETEER_EXECUTABLE_PATH="$CHROME_PATH"
else
    echo "Chrome installation failed or not found at $CHROME_PATH"
fi

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

bundle exec rails db:migrate