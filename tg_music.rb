require 'telegram/bot'
require 'net/http'
require 'json'
require 'open-uri'
require 'uri'
require 'logger'
require "vk-ruby"

token = '125138084:AAGSYcxwt_yJTyrhLTyqgviCmvwb1-2A-C4'
@log = Logger.new('log.txt')

def download_song(song_name)
  url = "https://api.vk.com/method/audio.search?
  access_token=7f8cbb7c49ef587fe95e041eb2a28325d79dce374
  7c97ce708fa5fbeed2990c78ef30eecf9d692520a6fe&q
  ="+song_name+"&count=1"
  url = URI.parse(URI.encode(url)).to_s.gsub("%0A%20%20","")
  uri = URI(url)
  response = Net::HTTP.get(uri)
  @log.debug song_name
  song_url = JSON.parse(response)["response"][1]["url"]
  open('song_from_vk.ogg', 'wb') do |file|
    file << open(song_url).read
  end
end
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    message.text
    begin
      download_song(message.text)
      bot.api.sendVoice(chat_id: message.chat.id, voice: File.new(__dir__ + "/song_from_vk.ogg"))
    rescue
      bot.api.sendMessage(chat_id: message.chat.id, text: "not found")
    end
    
  end
end

