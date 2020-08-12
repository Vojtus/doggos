# Doggos

## task

- expect an input parameter containing an array of dog breeds
- in five parallel threads downloads the data for those breeds from DogAPI (https://dog.ceo/dog-api/documentation)
- the results will be saved to CSV files with a header line (each breed into {breed_name}.csv) and contain columns: breed name and link to the image
- apart from those csv files the script will also create one file "updated_at.json" in JSON format that will contain a list of all the downloaded files and timestamp of when each of them was created
- The code should pass the Linter validation with default rubocop settings (https://github.com/rubocop-hq/rubocop)
- There should be a simple test using Rspec that will succeed on the code with testing/mocked data

To lanch the scrip, please:
`ruby doggo_script.rb bluetick borzoi bouvier ...`
