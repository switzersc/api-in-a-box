# sleep because compose doesn't wait to make sure elastic is ready
sleep 8

# run file grabber
ruby /api/data_processor/file_grabber.rb

# start API server
bundle exec rackup -p 4567 -o 0.0.0.0