module Knavebot
  module ParseHelper
    class UnrecognizedValueError < StandardError; end

    def int_value(arg)
      Integer(arg)
    rescue ArgumentError
      raise UnrecognizedValueError.new("did not recognize '#{arg}'")
    end
  end
end
