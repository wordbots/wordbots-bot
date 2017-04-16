require 'discordrb'
require 'json'
require 'erb'

include ERB::Util

bot = Discordrb::Bot.new(token: ENV['DISCORD_API_TOKEN'], client_id: ENV['DISCORD_APP_ID'])

bot.message(start_with: '[{"id":"') do |event|
  cards = JSON.parse(event.message.content)
  cards.each do |card|
    url = "http://app.wordbots.io/api/card.png?card=#{url_encode(JSON.generate(card))}"
    event.channel.send_embed do |embed|
      embed.title = card['name']
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: url)
    end
  end
end

bot.run
