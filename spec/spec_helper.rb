require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/index.rb'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }
