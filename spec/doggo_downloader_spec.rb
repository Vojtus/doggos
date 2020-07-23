# frozen_string_literal: true

require './doggo_downloader.rb'

RSpec.describe DoggoDownloader do
  describe '#download' do
    after(:each) do
      FileUtils.rm_rf('dogs/.', secure: true)
    end
    context 'given array of dog breeds' do
      let(:image_link) do
        'https://images.dog.ceo/breeds/hound-walker/n02089867_1882.jpg'
      end
      let(:dogs) { %w[bluetick borzoi bouvier affenpinscher cairn clumber] }
      before(:each) do
        dogs.each do |dog|
          stub_request(
            :get,
            "https://dog.ceo/api/breed/#{dog}/images"
          ).to_return(
            body: { 'message' => [image_link] }.to_json
          )
        end
      end

      it 'create files for first dog breed' do
        DoggoDownloader.new(dogs: dogs).download

        expect(File).to exist("dogs/#{dogs.first}.csv")
      end

      it 'create files for third dog breed' do
        DoggoDownloader.new(dogs: dogs).download

        expect(File).to exist("dogs/#{dogs[2]}.csv")
      end

      it 'create files for last dog breed' do
        DoggoDownloader.new(dogs: dogs).download

        expect(File).to exist("dogs/#{dogs.last}.csv")
      end

      it 'creates updated_at.json' do
        DoggoDownloader.new(dogs: dogs).download
        json = JSON.parse(File.read('dogs/updated_at.json'))

        expect(json).to have_key(dogs.first)
      end
    end
  end
end
