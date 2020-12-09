module Knavebot
  class Oracle
    def initialize(modifier = 0)
      @modifier = modifier
    end

    def determine_fate
      base_roll = DiceBag.new("2d6").roll

      case base_roll + @modifier
      when -Float::INFINITY..2
        :no_and
      when 3..4
        :no
      when 5..6
        :no_but
      when 7
        determine_fate
      when 8..9
        :yes_but
      when 10..11
        :yes
      when 12..Float::INFINITY
        :yes_and
      end
    end
  end
end
