RSpec.shared_examples "fate" do |input, expected|
  describe "roll of #{input}" do
    let(:roll) { input }

    it "should return fate" do
      expect(oracle.determine_fate).to eq([expected, input])
    end
  end
end

RSpec.shared_examples "reaction" do |input, expected|
  describe "roll of #{input}" do
    let(:roll) { input }

    it "should return reaction" do
      expect(oracle.determine_reaction).to eq([expected, input])
    end
  end
end

RSpec.describe Knavebot::Oracle do
  let(:roll) { 2 }
  let(:mock_bag) { double("DiceBag") }
  subject(:oracle) { described_class.new }

  describe "Oracle" do
    before do
      allow(Knavebot::DiceBag).to receive(:new).and_return(mock_bag)
      allow(mock_bag).to receive(:roll).and_return(roll)
    end

    describe "#determine_reaction" do
      it_behaves_like "reaction", 2, "Hostile"
      it_behaves_like "reaction", 3, "Unfriendly"
      it_behaves_like "reaction", 4, "Unfriendly"
      it_behaves_like "reaction", 5, "Unfriendly"
      it_behaves_like "reaction", 6, "Unsure"
      it_behaves_like "reaction", 8, "Unsure"
      it_behaves_like "reaction", 9, "Talkative"
      it_behaves_like "reaction", 10, "Talkative"
      it_behaves_like "reaction", 11, "Talkative"
      it_behaves_like "reaction", 12, "Helpful"
    end

    describe "#determine_fate" do
      it_behaves_like "fate", 2, "No! Furthermore, ..."
      it_behaves_like "fate", 3, "No."
      it_behaves_like "fate", 4, "No."
      it_behaves_like "fate", 5, "No, but ..."
      it_behaves_like "fate", 6, "No, but ..."
      it_behaves_like "fate", 8, "Yes, but ..."
      it_behaves_like "fate", 9, "Yes, but ..."
      it_behaves_like "fate", 10, "Yes."
      it_behaves_like "fate", 11, "Yes."
      it_behaves_like "fate", 12, "Yes! Furthermore, ..."

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
          got_fate, got_roll = oracle.determine_fate
          expect(got_fate).to eq("Yes, but ...")
          expect(got_roll).to eq(8)
        end
      end
    end
  end
end
