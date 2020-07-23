# frozen_string_literal: true

require './doggo_download_worker.rb'

RSpec.describe DoggoDownloadWorker do
  describe '#download' do
    after(:each) do
      FileUtils.rm_rf('dogs/.', secure: true)
    end

    let(:dogs) { %w[bluetick] }

    context 'given valid dog array' do
      let(:image_link) do
        'https://images.dog.ceo/breeds/hound-walker/n02089867_1882.jpg'
      end
      let(:expected_array) do
        [
          %w[BreedName ImageLink],
          %w[bluetick https://images.dog.ceo/breeds/hound-walker/n02089867_1882.jpg]
        ]
      end

      it 'creates correct csv file' do
        stub_request(
          :get,
          "https://dog.ceo/api/breed/#{dogs.first}/images"
        ).to_return(
          body: { 'message' => [image_link] }.to_json
        )
        DoggoDownloadWorker.new(dogs: dogs).download
        csv = CSV.open("dogs/#{dogs.first}.csv")

        expect(csv.to_a).to eq expected_array
      end
    end
  end
end
