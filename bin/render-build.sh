#!/usr/bin/env bash
set -o errexit

bundle install

# DB migration のみ（prepare は使わない）
bundle exec rake db:migrate

# アセットコンパイル
bundle exec rake assets:precompile
