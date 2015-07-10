gem 'faraday', '0.8.9' # requirement for stretcher
require "sinatra/base"
require 'stretcher'
# require 'pry'
# require 'rest-client'
# require 'json'

class ApiInABox < Sinatra::Base

  # TODO render in Collection Json format
  get "/resources" do
    search = server.index(:api).search() # TODO add queries
    docs = search.documents # only returns 10
    index_data = HTTParty.get("#{host}/api")
    mappings = index_data["api"]["mappings"]["resource"]["properties"] # or server.index(:api).get_mapping["api"]["mappings"]["resource"]["properties"] # to expose as queries
    content_type :json
    docs.to_json
  end

  def host
    @host = ENV["ELASTIC_HOST"] || "http://localhost:9200"
  end

  def server
    @server = Stretcher::Server.new(host)
  end
end