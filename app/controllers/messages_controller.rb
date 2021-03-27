require 'json'
require 'open-uri'
require 'rest-client'

class MessagesController < ApplicationController
  
  def index
    @messages = Message.all
    @message = Message.new
    @results = covid_data
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    if @message.save
      telegram_crossposting(@message.content)
      redirect_to root_path
    else
      redirect_to root_path
      flash[:notice] =  " Message invalid: #{@message.errors["content"][0]}"
    end
    
  end

  def covid_data
    url = 'https://api.covid19api.com/dayone/country/argentina'
    response = open(url).read
    data_array = JSON.parse(response)
    [data_array[-1], data_array.length ]
  end

  def telegram_crossposting(message)
    token = '1703817387:AAFqPLRSdbTH-9aXn1PsKikBlWDebW9q91Q'
    response = RestClient::Request.new(
      :method => :post,
      :url => "https://api.telegram.org/bot#{token}/sendMessage",
      :payload => {"chat_id": "-1001359045591", "text": "#{message}", "disable_notification": true}
    ).execute
    flash[:notice] =  "Message published in Telegram!"
  end

  private
  def message_params
    params.require(:message).permit(:content)
  end
end
