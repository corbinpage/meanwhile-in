class Search < ActiveRecord::Base
  INSTA_CLIENT_ID = ENV['MEANWHILE_IN_INSTA_CLIENT_ID'] # This is app specifc
  INSTA_CLIENT_SECRET = ENV['MEANWHILE_IN_INSTA_CLIENT_SECRET']
  GOOGLE_GEO_API_KEY  = ENV['MEANWHILE_IN_GOOGLE_GEO_API_KEY'] # This is app specifc
  MAX_CAPTION_LENGTH = 335
  INSTAGRAM_LOCATION_SEARCH_DISTANCE = 5000
  SAMPLE_LOCATIONS = {
                        0 =>[40.7143528,74.0059731,"New York"],       # New York
                        1 =>[48.856614,2.3522219,"Paris"],            # Paris
                        2 =>[43.585278,39.720278,"Sochi"],            # Sochi
                        3 =>[34.0522342,118.2436849,"Los Angelos"],   # LA
                        4 =>[35.6894875,139.6917064,"Tokyo"],         # Tokyo
                        5 =>[51.508515,0.1254872,"London"],           # London
                        6 =>[41.878114,-87.629798,"Chicago"],         # Chicago
                        7 =>[25.271139,55.307485,"Dubai"],            # Dubai
                        8 =>[-33.867487,151.206990,"Sydney"],         # Sydney
                        9 =>[41.892916,12.482520,"Rome"]              # Rome
                    }

  def get_result(search_text=nil)
    lat, lng, self.text = get_lat_lng(search_text)

    images = get_images(lat,lng)

    self.custom3 = images.count.to_s
    image = get_random_image(images)
    self.custom2, self.caption, self.username, self.url = get_image_properties(image)
  end

  def get_lat_lng(search_text=nil)
    return SAMPLE_LOCATIONS[rand(0..9)] if search_text.blank? || search_text.downcase.match('random')

    coordinates = get_coordinates(search_text)
    formatted_search_text = format_search_text(coordinates[2])
    [coordinates[0],coordinates[1],formatted_search_text]
  end

  def get_images(lat,lng)
    s = "https://api.instagram.com/v1/media/search?lat=#{lat}&lng=#{lng}&client_id=#{INSTA_CLIENT_ID}&distance=#{INSTAGRAM_LOCATION_SEARCH_DISTANCE}"

    uri = URI.parse(s)
    res = Net::HTTP.get_response(uri)
    j = JSON.parse(res.body)

    return j["data"].select {|d| d["type"].match("image")}
  end

  def get_coordinates(search_text)
    request = "https://maps.googleapis.com/maps/api/geocode/json?address=#{uri_substitute(search_text)}&sensor=false&key=#{GOOGLE_GEO_API_KEY}"

    uri = URI.parse(request)
    res = Net::HTTP.get_response(uri)
    j = JSON.parse(res.body)

    if j["status"] != "ZERO_RESULTS"
      coor = j["results"][0]["geometry"]["location"]
      [coor["lat"],coor["lng"],search_text]
    else
      get_lat_lng("random")
    end
  end


  def get_random_image(images)
    recent_searches = Search.where("custom1 like ?", "%#{self.custom1}%").limit(20).order(created_at: :desc)
    recent_ids = recent_searches.pluck(:custom2)

    image = images.find{|i| !recent_ids.include?(i["id"])}

    # i = image ? image : images.find{|i| i["id"].match(recent_ids.first)}

    if image
      puts "||||||First image|||||"
      images.sample
    elsif images.find{|i| i["id"].match(recent_ids.first)}
      puts "||||||Second image|||||"
      images.find{|i| i["id"].match(recent_ids.first)}
    else
      puts "||||||Not finding an Image||||||"
      images.sample
    end
  end

  def get_image_properties(image)
    [image["id"],
    image["caption"].nil? ? "" : trim_caption_text(image["caption"]["text"]),
    image["user"]["username"],
    image["images"]["standard_resolution"]["url"]]
  end

  def format_search_text(text)
    text.split(' ').collect(&:capitalize).join(' ')
  end

  def uri_substitute(string)
    string.gsub(/\s/,'+').gsub(/"/,"%22")
  end

  def trim_caption_text(text)
    return text if text.length <= MAX_CAPTION_LENGTH
    "#{text[1..MAX_CAPTION_LENGTH]}..."
  end

end
