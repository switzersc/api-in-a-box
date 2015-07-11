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
    p "Getting contents from repo"
    @contents = get_contents
    p "Got contents"
    @contents.each do |file|
      process_file(file)
    end
  end

  private

  def create_elastic_index
    unless (index = @server.index(@index)).exists?
      index.create
    end
  end

  # TODO validate URI and github repo
  def get_contents
    base = "https://api.github.com/repos/"
    url = base + @repo + "/contents"
    HTTParty.get(url)
  end

  # TODO add default mappings to ES so everything is a string
  # TODO don't add these rows if they already exist in database
  # TODO fix invalid csv files
  def process_file(file)
    # create remote_table object for file contents
    name = file["name"]
    p "Processing file #{name}"
    table = build_table(file)

    # binding.pry
    docs = table.rows.map do |row|
        row.merge({"FILE_SOURCE"=>name, "_type"=>"resource"})
    end
    # add json docs in bulk to elasticsearch
    @server.index(@index).bulk_index(docs)
  rescue => e
    p "Encountered error parsing file #{file}: #{e}"
    p "Skipping file #{file}"
  end

  # TODO add validations, exception handling
  def build_table(file)
    url = file["download_url"]
    name = file["name"]
    RemoteTable.new url, file_name: name
  end
end

# FileGrabber.new().run