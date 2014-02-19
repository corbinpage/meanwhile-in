class MeanwhileController < ApplicationController

  def index
    first = params[:text].nil? 

    # text = !first  ? params[:text] : "Charlotte, NC"

    search = Search.new(start_time: Time.now)
    #search = search.new(text: text)
    search.get_result
    search.save

    if !first
      respond_to do |format|
        if search.save
          #format.html { redirect_to "meanwhile#index", notice: 'Search successfully.' }
          #format.js   {"$('#pic').attr('src', 'instagram_example2.jpg');"}
          #format.js   {alert("Here!");}
          format.json { render json: search}
        else
          # format.html { redirect_to "meanwhile#index" }
          format.json { render json: search}
        end
      end
    end

  end

end




