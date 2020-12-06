module Knavebot
  module Command
    class Roll
      # ["d20", "+", "12"]
      def initialize(args)
        @args = args
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        "stub"
      end
    end
  end
end
