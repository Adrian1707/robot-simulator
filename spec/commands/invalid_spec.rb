require 'commands/invalid'

RSpec.describe Commands::Invalid do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:invalid_command) { Commands::Invalid.new(robot, table, output) }

  describe "#execute" do
    it "does not interact with the robot" do
      expect(robot).not_to receive(:placed?)

      invalid_command.execute
    end

    it "does not raise any error" do
      expect { invalid_command.execute }.not_to raise_error
    end
  end
end
