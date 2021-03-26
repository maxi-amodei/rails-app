require 'json'
require 'open-uri'
require 'telegram/bot'

class MessagesController < ApplicationController
  
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
      telegram_crossposting(message)
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

  def telegram_crossposting(message)
    token = '1703817387:AAFqPLRSdbTH-9aXn1PsKikBlWDebW9q91Q'
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/sitepoint'
          bot.api.send_message(chat_id: message.chat.id, text: "#{hello}")
        end
      end
    end
  end

  private
  def message_params
    params.require(:message).permit(:content)
  end
end
