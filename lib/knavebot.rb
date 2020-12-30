require "discordrb"
require "dotenv/load"

require "knavebot/version"
require "knavebot/bot"
require "knavebot/parse_helper"
require "knavebot/tokenizer"
require "knavebot/dice_bag"
require "knavebot/oracle"

require "knavebot/command/roll"

module Knavebot
  class Error < StandardError; end

  def self.run
    Bot.new.listen
  end
end
