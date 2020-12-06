module Knavebot
  class Bot
    def initialize
      @token = ENV["BOT_TOKEN"]
      # / is avoided since it's used by native Discord commands
      @prefix = "!"
    end

    def listen
      configure_commands

      client.run
    end

    private

    def configure_commands
      client.command([:r, :roll]) do |evt, *args|
        result = Command::Roll.call(args)
        evt << result
      end

      client.command([:ls, :list]) do |evt, *args|
        result = Command::List.call(args)
        evt << result
      end

      client.command([:h, :help]) do |evt|
        evt << "```"
        evt << "knavebot usage:"
        evt << ""
        evt << "#{@prefix}roll <expression>"
        evt << "      Roll dice and calculate expressions."
        evt << "      Example: `#{@prefix}r 2d8 + 10`"
        evt << ""
        evt << "```"
      end
    end

    def client
      @client ||= Discordrb::Commands::CommandBot.new(token: @token, prefix: @prefix)
    end
  end
end
