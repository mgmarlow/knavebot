module Knavebot
  class DiceBag
    include ParseHelper

    attr_accessor :n, :sides, :tally

    def initialize(dice_str)
      n, sides = dice_str.split("d")
      @n = n.empty? ? 1 : int_value(n)
      @sides = int_value(sides)
      @tally = []
    end

    def roll
      @tally = []

      n.times.inject(0) do |sum, _|
        result = rand(sides) + 1
        tally << result
        sum + result
      end
    end
  end
end
