class Action < ActiveRecord::Base

  #Creating an initialize method on the model doesn't work for some reason?
  #def initialize(text)
  #  @text = text
  #end

  def get_result
    self.url = 'instagram_example2.jpg' #hardcoded for now
    self.caption = 'This is my Caption!' #hardcoded for now
  end

  def new
  end


end
