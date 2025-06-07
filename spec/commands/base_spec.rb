require 'commands/base'

RSpec.describe Commands::Base do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:base_command) { Commands::Base.new(robot, table, output) }

  describe "#initialize" do
    it "creates a base command" do
      expect(base_command).not_to be_nil
    end
  end

  describe "#execute" do
    it "raises NotImplementedError" do
      expect { base_command.execute }.to raise_error(NotImplementedError, /Commands::Base has not implemented method 'execute'/)
    end
  end

  describe "#robot_placed?" do
    context "when robot is placed" do
      before do
        allow(robot).to receive(:placed?).and_return(true)
      end

      it "returns true" do
        expect(base_command.send(:robot_placed?)).to be true
      end
    end

    context "when robot is not placed" do
      before do
        allow(robot).to receive(:placed?).and_return(false)
      end

      it "returns false" do
        expect(base_command.send(:robot_placed?)).to be false
      end
    end
  end
end
