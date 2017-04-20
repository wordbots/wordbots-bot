require 'discordrb'
require 'json'
require 'erb'
require 'uri'
require 'active_support/core_ext/hash'

include ERB::Util

bot = Discordrb::Bot.new(token: ENV['DISCORD_API_TOKEN'], client_id: ENV['DISCORD_APP_ID'])

bot.message(start_with: ['[{"id":"', '{"id":"']) do |event|
  cards = JSON.parse(event.message.content)
  cards = [cards] if cards.is_a?(Hash)

  cards.each do |card|
    card.slice!('name', 'spriteID', 'type', 'cost', 'stats', 'text')
    puts card

    name, text = card['name'], card['text'].gsub('%27', '"')

    card['name'] = url_encode(card['name'])
    card['text'] = url_encode(card['text'])
    puts  JSON.generate(card)
    image_url = "http://app.wordbots.io/api/card.png?card=#{JSON.generate(card)}"

    event.respond "**#{name}**\n#{text}\n#{image_url}"
  end
end

bot.run
