module Knavebot
  module Command
    class UnrecognizedValueError < StandardError; end
    class OperatorEvalError < StandardError; end

    class Roll
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
          raise OperatorEvalError.new('tried to divide by zero') if b == 0

          a / b
        end,
        "*" => ->(a, b) { a * b }
      }

      def initialize(args)
        @args = args
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        # TODO: show results of dice rolls as well
        evaluate
      end

      private

      def evaluate
        result = []

        postfix_args.each do |arg|
          if operator?(arg)
            fn = OPERATOR_MAP[arg]

            result << fn.(*result.pop(fn.arity))
          elsif roll?(arg)
            result << roll_value(arg)
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

      def roll_value(arg)
        n, sides = arg.split("d")
        n = n.empty? ? 1 : int_value(n)
        sides = int_value(sides)

        n.times.inject(0) do |sum, _|
          sum + rand(sides) + 1
        end
      end

      def int_value(arg)
        Integer(arg)
      rescue ArgumentError => e
        raise UnrecognizedValueError.new("did not recognize #{arg}")
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
