class Search < ActiveRecord::Base
  INSTA_CLIENT_ID = '5acd491087a349acbcbddde9c92ab5c1' # This is app specifc
  INSTA_CLIENT_SECRET = 'b17108a913f246bb97e6ddc62aba5f76'
  GOOGLE_GEO_API_KEY  = 'AIzaSyDnhRqPgWa7YHYPNNRHoSXxBizLaqDc_fo' # This is app specifc
  
  MAX_CAPTION_LENGTH = 335
  #Creating an initialize method on the model doesn't work for some reason?
  #def initialize(text)
  #  @text = text
  #end

  def get_result(first=nil,search_text=nil)
    if first
      self.caption = nil
      self.username = nil
      self.url = nil
      return
    end

    client_id = INSTA_CLIENT_ID
    client_secret = INSTA_CLIENT_SECRET

    lat, lng, self.text = get_lat_lng(search_text)

    s = "https://api.instagram.com/v1/media/search?lat=#{lat}&lng=#{lng}&client_id=#{client_id}&distance=5000"

    uri = URI.parse(s)
    res = Net::HTTP.get_response(uri)
    j = JSON.parse(res.body)

    images = j["data"].select {|d| d["type"].match("image")}

    self.custom3 = images.count.to_s

    image = get_random_image(images)

    self.custom2 = image["id"]
    self.caption = image["caption"].nil? ? "" : trim_caption_text(image["caption"]["text"])
    self.username = image["user"]["username"]
    self.url = image["images"]["standard_resolution"]["url"]

  end

  def get_lat_lng(search_text=nil)

    api_key = GOOGLE_GEO_API_KEY

    if !search_text || search_text.downcase.match('random')
      locations = {
                    0 =>[40.7143528,74.0059731,"New York"],             # New York
                    1 =>[48.856614,2.3522219000000177,"Paris"],         # Paris
                    2 =>[43.585278,39.72027800000001,"Sochi"],          # Sochi
                    3 =>[34.0522342,118.2436849,"Los Angelos"],         # LA
                    4 =>[35.6894875,139.69170639999993,"Tokyo"],        # Tokyo
                    5 =>[51.508515,0.12548719999995228,"London"]        # London
                  }
      return locations[rand(0..5)]
    end

    s = "https://maps.googleapis.com/maps/api/geocode/json?address=#{uri_substitute(search_text)}&sensor=false&key=#{api_key}"

    uri = URI.parse(s)
    res = Net::HTTP.get_response(uri)
    j = JSON.parse(res.body)

    coordinates = j["results"][0]["geometry"]["location"]
    # formatted_search_text = j["results"][0]["formatted_address"] # Gets full address
    formatted_search_text = search_text.split(' ').collect(&:capitalize).join(' ')

    [coordinates["lat"],coordinates["lng"],formatted_search_text]
  end

  def get_random_image(images)
    recent_searches = Search.where("custom1 = ? AND custom2 IN (?)", self.custom1,images.collect{|i|i["id"]})
    # custom1 is IP address, custom2 is Instagram's media ID

    if recent_searches.count == 0
      return images[rand(0...images.count)] #if !recents
    else
      images.select {|i| !recent_searches.custom2.include? i["id"]}.sample
    end
  end

  def uri_substitute(string)
    string.gsub(/\s/,'+').gsub(/"/,"%22")
  end

  def trim_caption_text(text)
    return text if text.length <= MAX_CAPTION_LENGTH
    "#{text[1..MAX_CAPTION_LENGTH]}..."
  end

end
