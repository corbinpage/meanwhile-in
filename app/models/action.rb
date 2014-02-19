class Action < ActiveRecord::Base

  #Creating an initialize method on the model doesn't work for some reason?
  #def initialize(text)
  #  @text = text
  #end

  def get_result
    perform_search
  end

  def perform_search
    #require 'open-uri'
    #require 'net/http'

    client_id = '5acd491087a349acbcbddde9c92ab5c1'
    client_secret = 'b17108a913f246bb97e6ddc62aba5f76'

    locations = {
                  0 =>[40.7143528,74.0059731,"New York"],          # New York
                  1 =>[48.856614,2.3522219000000177,"Paris"],         # Paris
                  2 =>[43.585278,39.72027800000001,"Sochi"],          # Sochi
                  3 =>[34.0522342,118.2436849,"Los Angelos"],         # LA
                  4 =>[35.6894875,139.69170639999993,"Tokyo"],        # Tokyo
                  5 =>[51.508515,0.12548719999995228,"London"]        # London
                }

    lat, lng, self.text = locations[rand(0..5)]

    s = "https://api.instagram.com/v1/media/search?lat=#{lat}&lng=#{lng}&client_id=#{client_id}"

    uri = URI.parse(s)
    res = Net::HTTP.get_response(uri)
    j = JSON.parse(res.body)

    d = j["data"].select {|d| d["type"].match("image")}
    i = rand(0...d.count)

    self.caption = d[i]["caption"]["text"]
    self.username = d[i]["user"]["username"]
    self.url = d[i]["images"]["standard_resolution"]["url"]

  end


end
