require "sinatra/base"
# require 'pry'
# require 'rest-client'
# require 'json'

class ApiInABox < Sinatra::Base
  get "/resources" do
    content_type :json
    { :party => 'yes' }.to_json
  end
end