#!/usr/bin/env bash

echo "sleeping because compose doesn't wait to make sure elastic is ready"
sleep 8

echo "running the file grabber"
ruby /tmp/file_grabber.rb

echo "starting the API server with live reload"
rerun "bundle exec rackup -p 4567 -o 0.0.0.0"
