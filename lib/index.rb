require 'sinatra'

get '/api/quote' do
  authors = File.readlines('authors.txt').each {|l| l.chomp!}
  quotes = File.readlines('quotes.txt').each {|l| l.chomp!}
  randomIndex = rand(authors.length)

  <<EOF
  {
    "quote": "#{quotes[randomIndex]}",
    "author": "#{authors[randomIndex]}",
    "appVersion": "1.0.0",
    "environmentName": "#{ENV["ENVIRONMENT_NAME"] ||= "Development"}"
  }
EOF
end