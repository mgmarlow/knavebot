RSpec.describe Knavebot::Command::Fate do
  let(:args)        { [] }
  let(:mock_oracle) { double("Oracle") }
  let(:fate_result) { :yes }

  subject(:cmd) { described_class.new(args) }

  before do
    allow(Knavebot::Oracle).to receive(:new).and_return(mock_oracle)
    allow(mock_oracle).to receive(:determine_fate).and_return(fate_result)
  end

  describe "args are empty" do
    it "should create modifier" do
      expect(cmd.modifier).to eq(0)
    end

    it "should return fate result" do
      expect(cmd.call).to eq("Yes.")
    end
  end

  describe "args include strings" do
    let(:args) { ["foo", "bar", "5"] }

    it "should create modifier" do
      expect(cmd.modifier).to eq(0)
    end

    it "should return fate result" do
      expect(cmd.call).to eq("Yes.")
    end
  end

  describe "args are exploded" do
    let(:args) { ["+", "5"] }

    it "should create modifier" do
      expect(cmd.modifier).to eq(5)
    end

    it "should return fate result" do
      expect(cmd.call).to eq("Yes.")
    end
  end

  describe "args are condensed" do
    let(:args) { ["+5"] }

    it "should create modifier" do
      expect(cmd.modifier).to eq(5)
    end

    it "should return fate result" do
      expect(cmd.call).to eq("Yes.")
    end
  end

  describe "negative modifier" do
    let(:args) { ["-5"] }

    it "should create modifier" do
      expect(cmd.modifier).to eq(-5)
    end

    it "should return fate result" do
      expect(cmd.call).to eq("Yes.")
    end
  end
end
