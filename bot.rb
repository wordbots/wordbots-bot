require 'discordrb'
require 'json'
require 'erb'
require 'active_support/core_ext/hash'

include ERB::Util

bot = Discordrb::Bot.new(token: ENV['DISCORD_API_TOKEN'], client_id: ENV['DISCORD_APP_ID'])

bot.message(start_with: ['[{"id":"', '{"id":"']) do |event|
  cards = JSON.parse(event.message.content)
  cards = [cards] if cards.is_a?(Hash)

  cards.each do |card|
    card.slice!('name', 'type', 'cost', 'stats', 'text')
    name, text = card['name'], card['text']
    puts card

    card['name'] = url_encode(card['name'])
    card['text'] = url_encode(card['text'])
    image_url = "http://app.wordbots.io/api/card.png?card=#{JSON.generate(card)}"

    event.respond "**#{name}**\n#{text}\n#{image_url}"
  end
end

bot.run
