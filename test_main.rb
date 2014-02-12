require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'sinatra'
require 'open-uri'
require 'builder'
require 'gocardless'
require 'net/http'

configure :production do
    require 'newrelic_rpm'
end

##################################   TITLE   ##################################


require 'test/unit'

class MyUnitTests < Test::Unit::TestCase
    
    def setup
        puts "setup!"
    end
    
    def teardown
        puts "teardown!"
    end
    
    def test_basic
        puts "I RAN!"
    end
    
end