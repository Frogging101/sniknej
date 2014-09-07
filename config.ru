$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'bundler'
Bundler.require

require 'version'
require 'time_format'
require 'cache'
require 'jenkins'
require 'repo'

if ENV['SNIKNEJ_AUTH_USER'] and ENV['SNIKNEJ_AUTH_PASS']
  use Rack::Auth::Basic, 'Restricted Area - Butlers only' do |user, pass|
    user == ENV['SNIKNEJ_AUTH_USER'] and pass == ENV['SNIKNEJ_AUTH_PASS']
  end
end

get '/' do
  # FIXME: ???
  redirect "/#{Repo.all.last.name}"
end

get '/:name' do
  haml :index
end

get '/:name/:build' do
  haml :build
end

get '/:name/:build/:job/:id' do
  haml :job
end

run Sinatra::Application
