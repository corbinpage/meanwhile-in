class MeanwhileController < ApplicationController




  def index
    first = params[:text].nil? 

    # text = !first  ? params[:text] : "Charlotte, NC"

    action = Action.new(start_time: Time.now)
    #action = Action.new(text: text)
    action.get_result
    action.save

    if !first
      respond_to do |format|
        if action.save
          #format.html { redirect_to "meanwhile#index", notice: 'Search successfully.' }
          #format.js   {"$('#pic').attr('src', 'instagram_example2.jpg');"}
          #format.js   {alert("Here!");}
          format.json { render json: action}
        else
          # format.html { redirect_to "meanwhile#index" }
          format.json { render json: action}
        end
      end
    end

  end

end




