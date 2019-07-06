require 'sinatra'
require 'sinatra/reloader' if development?
require 'better_errors'
require 'dotenv'
require_relative 'rtl'
Dotenv.load

DEFAULT_URL = ENV['DEFAULT_URL'] || 'https://www.rtl.lu/news/national/a/1372563.html'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

configure { set :server, :puma }

set :public_folder, 'public'

get '/' do
  erb :home
end

post '/' do
  url = params[:url]
  options = {
    quality: params[:quality],
    verbose: false,
    target: './public'
  }
  video = RTL.parse(url, options)
  erb :videos, locals: {
    videos: [video],
  }
end

get '/robots.txt' do
  status 200
  body "User-agent: *\nDisallow: /"
end

get '/*' do
  redirect '/'
end

error do
  redirect '/'
end
