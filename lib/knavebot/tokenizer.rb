module Knavebot
  Token = Struct.new(:type, :value)

  class Tokenizer
    TOKEN_TYPES = [
      [:identifier, /\$\b[a-zA-Z]+\b/],
      [:integer, /\b[0-9]+\b/],
      [:oparen, /\(/],
      [:cparen, /\)/],
      [:roll, /\b[0-9]*d[0-9]+\b/],
      [:add, /\+/],
      [:sub, /-/],
      [:div, /\//],
      [:mul, /\*/]
      ].freeze

    def initialize(line)
      @line = line
      @tokens = []
    end

    def tokenize
      until @line.empty?
        @tokens << tokenize_one_token
        @line = @line.strip
      end

      @tokens
    end

    private

    def tokenize_one_token
      TOKEN_TYPES.each do |type, re|
        next unless @line =~ /\A(#{re})/

        value = $1
        @line = @line[value.length..-1]
        return Token.new(type, value)
      end

      raise "bad token match: #{@line.inspect}"
    end
  end
end
