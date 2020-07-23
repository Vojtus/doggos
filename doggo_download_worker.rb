# frozen_string_literal: true

require 'net/http'
require 'json'
require 'csv'

# Worker for doggo_downloader
class DoggoDownloadWorker
  def initialize(dogs:)
    @dogs = dogs.freeze
    @updated_at = {}
  end

  def download
    dogs.each do |dog|
      download_dog(dog)
    end

    updated_at
  end

  private

  attr_reader :dogs
  attr_accessor :updated_at

  def download_dog(dog)
    response = request(dog)
    images = parse(response)
    save_images(images, dog)
  end

  def request(dog)
    uri = URI("https://dog.ceo/api/breed/#{dog}/images")
    Net::HTTP.get(uri)
  end

  def parse(response)
    JSON.parse(response)['message']
  end

  def save_images(images, dog)
    headers = %w[BreedName ImageLink]
    CSV.open("dogs/#{dog}.csv", 'w') do |csv|
      csv << headers
      images.each do |image|
        csv << [dog, image]
      end
    end
    updated_at[dog] = Time.now
  end
end
