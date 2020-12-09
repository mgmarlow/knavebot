module Knavebot
  module Command
    class Fate
      attr_accessor :modifier, :args

      def initialize(args)
        @args = args
        # Need better validation rules for args
        # in Command classes.
        @modifier = args.join.empty? ? 0 : args.join.to_i
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        fate_result = Oracle.new(modifier).determine_fate
        print_fate(fate_result)
      end

      def print_fate(fate_result)
        case fate_result
        when :no_and
          "No! Furthermore, ..."
        when :no
          "No."
        when :no_but
          "No, but ..."
        when :yes_but
          "Yes, but ..."
        when :yes
          "Yes."
        when :yes_and
          "Yes! Furthermore, ..."
        end
      end
    end
  end
end
