RSpec.shared_examples "fate" do |input, expected|
  describe "roll of #{input}" do
    let(:roll) { input }

    it "should return fate" do
      expect(oracle.determine_fate).to eq(expected)
    end
  end
end

RSpec.describe Knavebot::Oracle do
  let(:roll) { 2 }
  let(:modifier) { 0 }
  let(:mock_bag) { double("DiceBag") }
  subject(:oracle) { described_class.new(modifier) }

  describe "#determine" do
    before do
      allow(Knavebot::DiceBag).to receive(:new).and_return(mock_bag)
      allow(mock_bag).to receive(:roll).and_return(roll)
    end

    it_behaves_like "fate", 2, :no_and
    it_behaves_like "fate", 3, :no
    it_behaves_like "fate", 4, :no
    it_behaves_like "fate", 5, :no_but
    it_behaves_like "fate", 6, :no_but
    it_behaves_like "fate", 8, :yes_but
    it_behaves_like "fate", 9, :yes_but
    it_behaves_like "fate", 10, :yes
    it_behaves_like "fate", 11, :yes
    it_behaves_like "fate", 12, :yes_and

    describe "roll of 7" do
      before do
        allow(oracle).to receive(:determine_fate).and_call_original
        allow(mock_bag).to receive(:roll).and_return(7, 8)
      end

      it "should call #determine twice" do
        oracle.determine_fate
        expect(oracle).to have_received(:determine_fate).twice
      end

      it "should return fate" do
        expect(oracle.determine_fate).to eq(:yes_but)
      end
    end

    describe "modifiers" do
      context "less than 12" do
        let(:modifier) { 1 }
        let(:roll) { 9 }

        it "should factor into result" do
          expect(oracle.determine_fate).to eq(:yes)
        end
      end

      context "greater than 12" do
        let(:modifier) { 1 }
        let(:roll) { 12 }

        it "should factor into result" do
          expect(oracle.determine_fate).to eq(:yes_and)
        end
      end
    end
  end
end
