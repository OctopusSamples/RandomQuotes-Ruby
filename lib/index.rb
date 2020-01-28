require 'sinatra'

get '/api/quote' do
  authors = File.readlines('authors.txt')
  quotes = File.readlines('quotes.txt')
  randomIndex = rand(authors.length)

  "{\"quote\": \"" + quotes[randomIndex] + "\", " +
      "\"author\": \"" + authors[randomIndex] + "\", " +
      "\"appVersion\": \"1.0.0\", " +
      "\"environmentName\": \"" + ENV["ENVIRONMENT_NAME"] ||= "Development" + "\" " +
      "}"
end