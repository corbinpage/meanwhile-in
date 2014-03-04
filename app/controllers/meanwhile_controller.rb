class MeanwhileController < ApplicationController

  def index
    first = params[:refresh].nil? 

    search = Search.new(start_time: Time.now, custom1: request.remote_ip)
    search.get_result(first, params[:text])
    search.save

    unless first 
      respond_to do |format|
        format.json { render json: search}
      end
    end
  end
end