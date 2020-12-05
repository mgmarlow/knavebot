module Knavebot
  class Bot
    def initialize
      @token = ENV["BOT_TOKEN"]
    end

    def listen
      configure_commands

      client.run
    end

    def configure_commands
      # /r d20 + 12 -> args: ["d20", "+", "12"]
      client.command [:r, :roll] do |evt, *args|
        # todo
      end

      client.command [:ls, :list] do |evt, *args|
        # todo
      end
    end

    def client
      @client ||= Discordrb::Commands::CommandBot.new(token: @token, prefix: "/")
    end
  end
end
