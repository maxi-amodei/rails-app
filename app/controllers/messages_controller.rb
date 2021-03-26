require 'json'
require 'open-uri'

class MessagesController < ApplicationController
  before_action :covid_data
  def index
    @messages = Message.all
    @message = Message.new
    @results = covid_data
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    if @message.save
      redirect_to root_path
    else
      render root_path
    end
  end

  def covid_data
    url = 'https://api.covid19api.com/dayone/country/argentina'
    response = open(url).read
    data_array = JSON.parse(response)

  [data_array[-1], data_array.length ]
  end
  private
  def message_params
    params.require(:message).permit(:content)
  end
end
