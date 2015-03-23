gem 'activesupport', '=4.0.1' # remote_table currently does not support 4.2.0
require 'active_support'
require 'httparty'
require 'stretcher' # elastic search client
require 'pry'
require 'remote_table'

class FileGrabber

  def initialize(repo)
    @repo = repo
    @index = :api_resource
    # @server = Stretcher::Server.new('http://localhost:9200')
  end

  def run
    # setup_database
    @contents = get_contents
    @contents.each do |file|
      process_file(file)
    end
  end

  private

  def create_elastic_index
    @server.index(@index).create # make sure doesnt create if it already exists
  end

  def create_mapping
    # this maybe should be done at the CSV level, with type being the csv file_name and the properties being the column headers
    # unless everything should be of one type and then the csv name is just an attribute on each document
    # type/mapping is probably more like table name - so if we let different types of resources be in directories named by type

  end

  def dump_json(row, file_name)
    # convert to json
    # merge {name: file_name}
    # dump in ES server

  end

  def get_contents
    base = "https://api.github.com/repos/"
    url = base + @repo + "/contents"  # TODO check valid URI and github repo
    HTTParty.get(url)
  end

  def process_file(file)
    # create remote_table object for file contents
    url = file["download_url"]
    name = file["name"] # TODO check for file type
    t = RemoteTable.new url, file_name: name

    # add "FILE_SOURCE" attribute to json rows
    # row is already formatted in json with headers as keys and row values as the values,
    # so just need to add source (for reference) and _type (for ES)
    docs = t.rows.map{|row| row.merge({"FILE_SOURCE"=>name, "_type"=>@type.to_s}}

    # add mappings to ES
    type = name
    @server.index(@index).create(mappings: {tweet: {properties: {text: {type: 'string'}}}})

    # add json docs in bulk to elasticsearch
    @server.index(@index).bulk_index(docs)
  end

  def setup_database
    create_elastic_index
    create_mapping
  end
end