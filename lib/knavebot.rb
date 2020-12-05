require "knavebot/version"
require "discordrb"
require "dotenv/load"

module Knavebot
  class Error < StandardError; end

  def self.run
    bot = Discordrb::Bot.new(token: ENV["BOT_TOKEN"])

    bot.message(with_text: "Ping!") do |evt|
      evt.respond("Pong!")
    end

    bot.run
  end
end
