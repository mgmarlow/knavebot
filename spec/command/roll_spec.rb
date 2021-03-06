RSpec.describe Knavebot::Command::Roll do
  let(:args) { [] }

  subject(:cmd) { described_class.new(args) }

  describe "bad arguments" do
    let(:args) { ["asdf"] }

    it "should throw an error" do
      expect {
        cmd.call
      }.to raise_error("bad token match: \"asdf\"")
    end
  end

  describe "addition" do
    let(:args) { ["20", "+", "12"] }

    it "should calculate expression" do
      expect(cmd.call.total).to eq(32)
    end
  end

  describe "subtraction" do
    let(:args) { ["20", "-", "12"] }

    it "should calculate expression" do
      expect(cmd.call.total).to eq(8)
    end
  end

  describe "multiplication" do
    let(:args) { ["20", "*", "2"] }

    it "should calculate expression" do
      expect(cmd.call.total).to eq(40)
    end
  end

  describe "division" do
    let(:args) { ["20", "/", "2"] }

    it "should calculate expression" do
      expect(cmd.call.total).to eq(10)
    end
  end

  describe "divide by 0" do
    let(:args) { ["20", "/", "0"] }

    it "should calculate expression" do
      expect {
        cmd.call
      }.to raise_error("tried to divide by zero")
    end
  end

  describe "pemdas" do
    describe "with parens" do
      let(:args) { ["12", "*", "(", "3", "+", "4", ")"] }

      it "should calculate expression" do
        expect(cmd.call.total).to eq(84)
      end
    end

    describe "without parens" do
      let(:args) { ["12", "*", "3", "+", "4"] }

      it "should calculate expression" do
        expect(cmd.call.total).to eq(40)
      end
    end

    describe "missing matching paren" do
      let(:args) { ["12", "*", "(", "3", "+", "4"] }

      it "should throw error" do
        expect {
          cmd.call
        }.to raise_error("did not recognize '('")
      end
    end
  end

  describe "rolls" do
    before do
      srand(67890)
    end

    describe "single roll" do
      let(:args) { ["d20"] }

      it "should return RollResult" do
        got = cmd.call
        expect(got.total).to eq(17)
        expect(got.rolls).to eq("d20 (17)")
      end
    end

    describe "multiple rolls" do
      let(:args) { ["4d20"] }

      it "should calculate expression" do
        got = cmd.call
        expect(got.total).to eq(50)
        expect(got.rolls).to eq("4d20 (17, 11, 2, 20)")
      end
    end

    describe "multiple rolls with arithmetic" do
      let(:args) { ["4d20", "+", "2d8"] }

      it "should calculate expression" do
        got = cmd.call
        expect(got.total).to eq(54)
        expect(got.rolls).to eq("4d20 (17, 11, 2, 20) + 2d8 (3, 1)")
      end
    end
  end
end
