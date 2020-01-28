require 'sinatra'

get '/api/quote' do
  path = File.expand_path(File.dirname(__FILE__)) + "/"
  authors = File.readlines(path + 'authors.txt').each {|l| l.chomp!}
  quotes = File.readlines(path + 'quotes.txt').each {|l| l.chomp!}
  randomIndex = rand(authors.length)

  <<EOF
  {
    "quote": "#{quotes[randomIndex]}",
    "author": "#{authors[randomIndex]}",
    "appVersion": "1.0.0",
    "environmentName": "#{ENV["RACK_ENV"] ||= "Development"}"
  }
EOF
end