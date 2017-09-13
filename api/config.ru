require 'rubygems'
require 'bundler'

Bundler.require

require './api'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => :get
  end
end

run ApiInABox
