# frozen_string_literal: true

require 'rubygems'
require 'fileutils'
require 'active_support/all'
require './doggo_download_worker.rb'

# Downloads image links to files
class DoggoDownloader
  def initialize(dogs:, thread_count: 5)
    @dogs = dogs.freeze
    @thread_count = thread_count.freeze
    @threads = []
  end

  def download
    launch_threads
    wait
    create_updated_at_file
  end

  private

  attr_reader :dogs, :thread_count
  attr_accessor :threads

  def launch_threads
    dogs.in_groups(thread_count, false) do |group|
      threads << Thread.new do
        Thread.current[:output] =
          DoggoDownloadWorker.new(dogs: group).download
      end
    end
  end

  def wait
    threads.each(&:join)
  end

  def create_updated_at_file
    updated_at = {}
    threads.each { |t| updated_at.merge!(t[:output]) }

    File.open('dogs/updated_at.json', 'w') do |f|
      f.write(updated_at.to_json)
    end
  end
end
