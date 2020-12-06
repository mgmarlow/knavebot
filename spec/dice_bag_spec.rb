RSpec.describe Knavebot::DiceBag do
  let(:dice_str) { "d20" }

  let(:bag) { described_class.new(dice_str) }

  before do
    srand(67890)
  end

  describe "#tally" do
    context "before dice is rolled" do
      it "should be empty" do
        expect(bag.tally).to eq([])
      end
    end

    context "multiple rolls" do
      let(:dice_str) { "d20" }

      it "should clear tally" do
        bag.roll
        expect(bag.tally).to eq([17])

        bag.roll
        expect(bag.tally).to eq([11])
      end
    end
  end

  describe "n is provided" do
    let(:dice_str) { "4d20" }

    it "should roll dice with n=n" do
      expect(bag.roll).to eq(50)
      expect(bag.tally).to eq([17, 11, 2, 20])
    end
  end

  describe "n is implicit" do
    let(:dice_str) { "d20" }

    it "should roll dice with n=1" do
      expect(bag.roll).to eq(17)
      expect(bag.tally).to eq([17])
    end
  end

  describe "sides is not integer value" do
    it "should raise_error" do
      expect {
        described_class.new("dfoo")
      }.to raise_error(/did not recognize 'foo'/)
    end
  end
end
