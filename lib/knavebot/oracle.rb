module Knavebot
  class Oracle
    def determine_fate
      roll = DiceBag.new("2d6").roll

      result = case roll
      when 2
        "No! Furthermore, ..."
      when 3..4
        "No."
      when 5..6
        "No, but ..."
      when 7
        return determine_fate
      when 8..9
        "Yes, but ..."
      when 10..11
        "Yes."
      when 12
        "Yes! Furthermore, ..."
      end

      [result, roll]
    end

    def determine_reaction
      roll = DiceBag.new("d12").roll

      result = case roll
      when 2
        "Hostile"
      when 3..5
        "Unfriendly"
      when 6..8
        "Unsure"
      when 9..11
        "Talkative"
      when 12
        "Helpful"
      end

      [result, roll]
    end
  end
end
