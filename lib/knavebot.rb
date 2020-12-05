require "discordrb"
require "dotenv/load"

require "knavebot/version"
require "knavebot/bot"

module Knavebot
  class Error < StandardError; end

  def self.run
    Bot.new.listen
  end
end
