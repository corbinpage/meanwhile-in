class MeanwhileController < ApplicationController

  def index
    first = params[:text].nil? 

    search = Search.new(start_time: Time.now)
    search.get_result
    search.save

    if !first
      respond_to do |format|
        if search.save
          format.json { render json: search}
        else
          format.json { render json: search}
        end
      end
    end

  end

end




