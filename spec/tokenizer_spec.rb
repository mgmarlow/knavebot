RSpec.describe Knavebot::Tokenizer do
  let(:args) { [] }

  subject(:tokenizer) { described_class.new(args) }

  describe "left side" do
    let(:args) { ["20+", "12"] }

    it "should return result" do
      expect(tokenizer.tokenize).to eq([
        Knavebot::Token.new(:integer, "20"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "12")
      ])
    end
  end

  describe "right side" do
    let(:args) { ["20", "+12"] }

    it "should return result" do
      expect(tokenizer.tokenize).to eq([
        Knavebot::Token.new(:integer, "20"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "12")
      ])
    end
  end

  describe "one expression" do
    let(:args) { ["20+12"] }

    it "should return result" do
      expect(tokenizer.tokenize).to eq([
        Knavebot::Token.new(:integer, "20"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "12")
      ])
    end
  end

  describe "multiple operations" do
    let(:args) { ["5+2*12"] }

    it "should return result" do
      expect(tokenizer.tokenize).to eq([
        Knavebot::Token.new(:integer, "5"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "2"),
        Knavebot::Token.new(:mul, "*"),
        Knavebot::Token.new(:integer, "12")
      ])
    end
  end

  describe "multiple operations with repeating operators" do
    let(:args) { ["5+2*12+3"] }

    it "should return result" do
      expect(tokenizer.tokenize).to eq([
        Knavebot::Token.new(:integer, "5"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "2"),
        Knavebot::Token.new(:mul, "*"),
        Knavebot::Token.new(:integer, "12"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "3")
      ])
    end
  end

  describe "multiple operations with repeating operators and inconsistent whitespace" do
    let(:args) { ["5+2*12", "+", "3"] }

    it "should return result" do
      expect(tokenizer.tokenize).to eq([
        Knavebot::Token.new(:integer, "5"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "2"),
        Knavebot::Token.new(:mul, "*"),
        Knavebot::Token.new(:integer, "12"),
        Knavebot::Token.new(:add, "+"),
        Knavebot::Token.new(:integer, "3")
      ])
    end
  end

  describe "rolls" do
    describe "roll with implicit n" do
      let(:args) { ["d20"] }

      it "should return result" do
        expect(tokenizer.tokenize).to eq([
          Knavebot::Token.new(:roll, "d20")
        ])
      end
    end

    describe "roll with n" do
      let(:args) { ["4d20"] }

      it "should return result" do
        expect(tokenizer.tokenize).to eq([
          Knavebot::Token.new(:roll, "4d20")
        ])
      end
    end

    describe "left side" do
      let(:args) { ["d20+15"] }

      it "should return result" do
        expect(tokenizer.tokenize).to eq([
          Knavebot::Token.new(:roll, "d20"),
          Knavebot::Token.new(:add, "+"),
          Knavebot::Token.new(:integer, "15")
        ])
      end
    end

    describe "right side" do
      let(:args) { ["15+d20"] }

      it "should return result" do
        expect(tokenizer.tokenize).to eq([
          Knavebot::Token.new(:integer, "15"),
          Knavebot::Token.new(:add, "+"),
          Knavebot::Token.new(:roll, "d20")
        ])
      end
    end

    describe "middle" do
      let(:args) { ["15+d20*5"] }

      it "should return result" do
        expect(tokenizer.tokenize).to eq([
          Knavebot::Token.new(:integer, "15"),
          Knavebot::Token.new(:add, "+"),
          Knavebot::Token.new(:roll, "d20"),
          Knavebot::Token.new(:mul, "*"),
          Knavebot::Token.new(:integer, "5")
        ])
      end
    end
  end

  describe "special keywords" do
    let(:args) { ["$reaction"] }

    it "should return result" do
      expect(tokenizer.tokenize).to eq([
        Knavebot::Token.new(:identifier, "$reaction")
      ])
    end
  end
end
