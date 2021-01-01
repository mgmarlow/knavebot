RSpec.describe Knavebot::Bot do
  let(:client_double) { double(:client) }

  let(:bot) { described_class.new }

  before do
    allow(client_double).to receive(:run)
    allow(client_double).to receive(:command)
    allow(bot).to receive(:client).and_return(client_double)
  end

  describe "#initialize" do
    it "should set prefix to !" do
      expect(bot.instance_variable_get("@prefix")).to eq("!")
    end
  end

  describe "#listen" do
    before do
      bot.listen
    end

    it "should configure rolling" do
      expect(client_double).to have_received(:command).with(:roll, aliases: [:r])
    end

    it "should configure help" do
      expect(client_double).to have_received(:command).with(:help, aliases: [:h])
    end

    it "should call client#run" do
      expect(client_double).to have_received(:run)
    end
  end
end
