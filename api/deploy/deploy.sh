
# run file grabber
ruby ../data_processor/file_grabber.rb

# start API server
bundle exec rackup -p 4567 -o 0.0.0.0