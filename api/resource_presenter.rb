require 'collection-json'
class ResourcePresenter

  def initialize(options={})
    @resources = options[:resources] # required
    @queries = options[:queries]     # optional
  end

  def as_json
    CollectionJSON.generate_for('/resources/') do |builder|
      @resources.each do |resource|
        builder.add_item("/resources/#{resource._id}") do |item|
          resource.each do |k,v|
            item.add_data k, value: v
          end
        end
      end

      if @queries
        builder.add_query("/resources/search", "search", prompt: "Search") do |query|
          # queries for each column name from CSVs
          @queries.each do |q|
            query.add_data q
          end
          # other useful queries
          query.add_data "match_phrase" # if you want to match the exact phrase given in another param, pass true
          query.add_data "size" # how many results you want back at once. 50 is default
          query.add_data "from" # where you would like to begin in the results array. default is 0 (the first result, then you get results 1-50)
        end
      end
    end
  end
end