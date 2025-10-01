#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# DB 準備
bundle exec rake db:prepare

# アセットコンパイル
bundle exec rake assets:precompile
bundle exec rake assets:clean
