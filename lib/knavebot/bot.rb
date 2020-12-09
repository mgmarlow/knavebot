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
        evt << Command::Roll.call(args)
      end

      client.command([:f, :fate]) do |evt, *args|
        evt << Command::Fate.call(args)
      end

      client.command([:h, :help]) do |evt|
        evt << "```"
        evt << "knavebot usage:"
        evt << ""
        evt << "#{@prefix}roll <expression>"
        evt << "      Roll dice and calculate expressions."
        evt << "      Example: `#{@prefix}r 2d8 + 10`"
        evt << ""
        evt << "#{@prefix}fate [+|- modifier]"
        evt << "      Ask the Oracle a question and consult with your fate."
        evt << "      Example: `#{@prefix}fate` => 'Yes, but ...'"
        evt << ""
        evt << "```"
      end
    end

    def client
      @client ||= Discordrb::Commands::CommandBot.new(token: @token, prefix: @prefix)
    end
  end
end
