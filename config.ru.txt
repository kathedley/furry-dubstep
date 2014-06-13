require 'rubygems' 
require 'bundler'  
Bundler.require  
require './lookup'
run Sinatra::Application

$stdout.sync = true