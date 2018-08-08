require_relative 'stores'
require_relative './util/onemap'

data = Array.new
onemap_client = OneMapClient.new

methods = Stores.methods(false)
methods.each do |m|
  puts "Processing #{m}"
  data.push *Stores.public_send(m)
end

for shop in data do
  post_code = shop.address.scan(/(\d{6})/).flatten.first
  puts "Finding location for #{shop.title}. Postal: #{post_code}"
  shop.location = onemap_client.search(post_code).first
  sleep(0.5)
end

puts JSON.pretty_generate(data)
