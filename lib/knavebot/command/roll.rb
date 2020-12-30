module Knavebot
  module Command
    class OperatorEvalError < StandardError; end

    class Roll
      include ParseHelper

      PRECEDENCE = {
        add: 1,
        sub: 1,
        div: 2,
        mul: 2,
        cparen: 3,
        oparen: 3
      }

      OPERATOR_MAP = {
        add: ->(a, b) { a + b },
        sub: ->(a, b) { a - b },
        mul: ->(a, b) { a * b },
        div: ->(a, b) do
          raise OperatorEvalError.new("tried to divide by zero") if b == 0

          a / b
        end
      }

      IDENTIFIER_MAP = {
        "$reaction" => -> {
          reaction = Oracle.new.determine_reaction

          "**Result**: #{reaction}"
        },
        "$fate" => -> {
          fate = Oracle.new.determine_fate

          "**Result**: #{fate}"
        }
      }

      def initialize(args)
        @args = args
        @tallies = []
      end

      def self.call(*args)
        new(*args).call
      end

      def call
        @tokens = Knavebot::Tokenizer.new(@args.join("")).tokenize
        result = evaluate

        if @tallies.empty?
          result
        else
          formatted_tallies = @tallies
            .map { |t| "(#{t.join(", ")})" }
            .join(", ")

          "#{formatted_tallies}\n**Total**: #{result}"
        end
      rescue => e
        "Couldn't evaluate roll (#{e.message})."
      end

      private

      def evaluate
        result = []

        postfix_tokens.each do |token|
          if operator?(token)
            fn = OPERATOR_MAP[token.type]

            result << fn.call(*result.pop(fn.arity))
          elsif roll?(token)
            bag = DiceBag.new(token.value)
            result << bag.roll
            @tallies << bag.tally
          elsif token.type == :identifier
            fn = IDENTIFIER_MAP[token.value]
            raise "identifier #{token.value} not found" if fn.nil?

            # Identifiers currently exclude arithmetic
            return fn.call
          else
            result << int_value(token.value)
          end
        end

        result.first
      end

      def operator?(token)
        !!OPERATOR_MAP[token.type]
      end

      def roll?(token)
        token.type == :roll
      end

      def postfix_tokens
        output = []
        operators = []

        @tokens.each do |token|
          case token.type
          when :add, :sub, :mul, :div
            until operators.empty? ||
                operators[-1].type == :oparen ||
                PRECEDENCE[operators[-1].type] <= PRECEDENCE[token.type]
              output << operators.pop
            end

            operators << token
          when :oparen
            operators << token
          when :cparen
            until operators[-1].type == :oparen || operators.empty?
              output << operators.pop
            end

            # Discard left paren
            operators.pop
          else
            output << token
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
