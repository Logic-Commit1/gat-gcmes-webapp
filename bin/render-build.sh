#!/usr/bin/env bash
# exit on error
set -o errexit

npm install puppeteer --global
npx puppeteer browsers install chrome
echo "Puppeteer installed and Chrome is being fetched..."

# Check if the Chrome executable is available
if command -v google-chrome-stable &> /dev/null
then
    echo "Chrome is installed successfully."
else
    echo "Chrome installation failed or not found."
fi

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

bundle exec rails db:migrate