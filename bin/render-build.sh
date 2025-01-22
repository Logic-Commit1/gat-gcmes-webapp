#!/usr/bin/env bash
# exit on error
set -o errexit

curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o chrome.deb
apt-get update && apt-get install -y ./chrome.deb

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

bundle exec rails db:migrate