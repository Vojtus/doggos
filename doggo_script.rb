require 'byebug'
require './doggo_downloader.rb'

DoggoDownloader.new(dogs: ARGV).download
