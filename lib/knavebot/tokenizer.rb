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
    ]

    def initialize(args)
      @line = args.join("")
      @tokens = []
    end

    def tokenize
      until @line.empty?
        @tokens << find_token
        @line = @line.strip
      end

      @tokens
    end

    private

    def find_token
      TOKEN_TYPES.each do |type, re|
        match = @line.match(/\A(#{re})/)
        if match
          value = match[1]
          @line = @line[value.length..-1]
          return Token.new(type, value)
        end
      end
    end
  end
end
