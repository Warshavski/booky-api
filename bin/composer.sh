#!/bin/sh

rm -rf /app/tmp/pids /tmp/unicorn.pid

# DB stuff
bin/rake db:create db:migrate db:truncate_all db:seed

# Run app
bin/rails s -b '0.0.0.0'
