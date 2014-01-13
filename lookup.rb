require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'nokogiri'

get '/uk/publication/:pub_number' do
    # the variable is params[:pub_name]
    "Hello #{params[:pub_number]} world!"
end