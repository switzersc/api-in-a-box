gem 'faraday', '0.8.9'
gem 'activesupport', '=4.0.1'
require 'active_support'
require 'httparty'
require 'stretcher' # elastic search client
require 'pry'
require 'remote_table'

class FileGrabber

  def initialize(options={})
    @repo = options[:repo] || ENV["ORIGIN_REPO"]
    @index = options[:index] || :api
    @host = ENV["ELASTIC_HOST"] || "http://localhost:9200"
    @server = Stretcher::Server.new(@host)
  end

  def run
    create_elastic_index
    @contents = get_contents
    @contents.each do |file|
      process_file(file)
    end
  end

  private

  def create_elastic_index
    @server.index(@index).create
  end

  # TODO validate URI and github repo
  def get_contents
    base = "https://api.github.com/repos/"
    url = base + @repo + "/contents"
    HTTParty.get(url)
  end

  # TODO add default mappings to ES so everything is a string
  def process_file(file)
    # create remote_table object for file contents
    table = build_table(file)

    # add "FILE_SOURCE" attribute to json rows
    # row is already formatted in json with headers as keys and row values as the values,
    # so just need to add source (for reference) and _type (for ES)
    docs = table.rows.map{|row| row.merge({"FILE_SOURCE"=>name, "_type"=>"resource"})}

    # add json docs in bulk to elasticsearch
    @server.index(@index).bulk_index(docs)
  end

  # TODO add validations, exception handling
  def build_table(file)
    url = file["download_url"]
    name = file["name"]
    RemoteTable.new url, file_name: name
  end
end

FileGrabber.new().run