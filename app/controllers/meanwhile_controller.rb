class MeanwhileController < ApplicationController




  def index
    text = !params[:text].nil?  ? params[:text] : "Charlotte, NC"

    action = Action.new(text: text, start_time: Time.now)
    action.get_result
    action.save
  end

  def search
    puts "|||||SEARCH"
    text = !params[:text].nil?  ? params[:text] : "Charlotte, NC"

    action = Action.new(text: text, start_time: Time.now)
    action.get_result
    
    respond_to do |format|
      if action.save
        format.html { redirect_to "meanwhile/index", notice: 'Search successfully.' }
        format.js   {"$('#pic').attr('src', 'instagram_example2.jpg');"}
        format.json { render json: action}
      else
        format.html { redirect_to "meanwhile/index" }
        format.json { render json: action}
      end
    end
  end

end




