module Knavebot
  module Command
    class OperatorEvalError < StandardError; end

    class Roll
      include ParseHelper

      PRECEDENCE = {
        "+" => 1,
        "-" => 1,
        "/" => 2,
        "*" => 2,
        ")" => 3,
        "(" => 3
      }

      OPERATOR_MAP = {
        "+" => ->(a, b) { a + b },
        "-" => ->(a, b) { a - b },
        "/" => ->(a, b) do
          raise OperatorEvalError.new("tried to divide by zero") if b == 0

          a / b
        end,
        "*" => ->(a, b) { a * b }
      }

      def initialize(args)
        @args = args
        @tallies = []
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        result = evaluate

        if @tallies.empty?
          result
        else
          formatted_tallies = @tallies
            .map { |t| "(#{t.join(", ")})" }
            .join(", ")

          "#{result} #{formatted_tallies}"
        end
      rescue => e
        "Couldn't evaluate roll (#{e.message})."
      end

      private

      def evaluate
        result = []

        postfix_args.each do |arg|
          if operator?(arg)
            fn = OPERATOR_MAP[arg]

            result << fn.call(*result.pop(fn.arity))
          elsif roll?(arg)
            bag = DiceBag.new(arg)
            result << bag.roll
            @tallies << bag.tally
          else
            result << int_value(arg)
          end
        end

        result.first
      end

      def operator?(arg)
        !!OPERATOR_MAP[arg]
      end

      def roll?(arg)
        arg.match(/\d*d\d/i)
      end

      def postfix_args
        output = []
        operators = []

        @args.each do |arg|
          case arg
          when "+", "-", "*", "/"
            until operators.empty? || operators[-1] == "(" || PRECEDENCE[operators[-1]] <= PRECEDENCE[arg]
              output << operators.pop
            end

            operators << arg
          when "("
            operators << arg
          when ")"
            until operators[-1] == "(" || operators.empty?
              output << operators.pop
            end

            # Discard left paren
            operators.pop
          else
            output << arg
          end
        end

        until operators.empty?
          output << operators.pop
        end

        output
      end
    end
  end
end
