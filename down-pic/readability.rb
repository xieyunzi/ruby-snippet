require 'rubygems'
require 'readability'
require 'open-uri'

source = open('http://bing.com').read
puts Readability::Document.new(source).content