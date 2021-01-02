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
      client.command(:roll, aliases: [:r]) do |evt, *args|
        result = Command::Roll.call(args)
        evt.message.reply(
          """
#{evt.user.mention} rolling the 🎲
Result: #{result.rolls}
**Total: #{result.total}**
          """
        )
      rescue => e
        "Couldn't evaluate roll (#{e.message})"
      end

      # TODOs:
      # client.command(:create, aliases: [:c]) do |evt, *args|
      #   evt << Command::Create.call(args)
      # end

      # client.command(:dm) do |evt, *args|
      #   evt << Command::DungeonMaster.call(args)
      # end

      client.command(:about) do |evt|
        evt.send_embed do |embed|
          embed.color = "0099ff"
          embed.title = "Knavebot"
          embed.description = """
A TTRPG bot for Knave and other old-school RPGs.

Open source now and forever: https://github.com/mgmarlow/knavebot
          """
        end
      end

      client.command(:help, aliases: [:h]) do |evt|
        evt << "`!help` me use knavebot:"
        evt << "```"
        evt << "#{@prefix}roll <expression>"
        evt << "  Roll dice and calculate expressions."
        evt << "  Example: `#{@prefix}r 2d8 + 10`"
        evt << ""
        evt << "  Special rolls"
        evt << "  -------------"
        evt << "  - Roll reactions with `!r $reaction`"
        evt << "  - Roll fates with `!r $fate`"
        evt << ""
        evt << "#{@prefix}about"
        evt << "  About Knavebot."
        evt << ""
        evt << "#{@prefix}help"
        evt << "  View help."
        evt << "```"
      end
    end

    def client
      @client ||= Discordrb::Commands::CommandBot.new(token: @token, prefix: @prefix)
    end
  end
end
