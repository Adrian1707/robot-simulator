require 'commands/base'

RSpec.describe Commands::Base do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:base_command) { Commands::Base.new(robot, table, output) }

  describe "#initialize" do
    it "assigns robot, table, and output" do
      expect(base_command.robot).to eq(robot)
      expect(base_command.table).to eq(table)
      expect(base_command.output).to eq(output)
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
