require "discordrb"
require "dotenv/load"

require "knavebot/version"
require "knavebot/bot"
require "knavebot/command/roll"
require "knavebot/command/list"

module Knavebot
  class Error < StandardError; end

  def self.run
    Bot.new.listen
  end
end
