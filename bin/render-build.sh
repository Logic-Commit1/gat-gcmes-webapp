#!/usr/bin/env bash
# exit on error
set -o errexit

rm -rf package-lock.json node_modules
npm install
npm list
npx @puppeteer/browsers install chrome@131.0.6778.87


bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

# bundle exec rails db:migrate
