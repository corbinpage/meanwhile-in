require 'open-uri'
require 'net/http'

CLIENT_ID = '5acd491087a349acbcbddde9c92ab5c1'
CLIENT_SECRET = 'b17108a913f246bb97e6ddc62aba5f76'
lat = '48.858844'
lng = '2.294351'


s = "https://api.instagram.com/v1/media/search?lat=#{lat}&lng=#{lng}&client_id=#{CLIENT_ID}"
puts s

uri = URI.parse(s)
res = Net::HTTP.get_response(uri)

puts res.body if res.is_a?(Net::HTTPSuccess)