class MeanwhileController < ApplicationController

  def index
    search = Search.new(start_time: Time.now, custom1: request.remote_ip.to_s.chomp)
    search.get_result(params[:text])
    search.save
    @data = search

    unless params[:refresh].nil? # Checks whether it's the initial load
      respond_to do |format|
        format.json {render json: search}
      end
    end
    #Loads default erb if it's the initial load => index.html.erb
  end
end