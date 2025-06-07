require 'commands/left'

RSpec.describe Commands::Left do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:left_command) { Commands::Left.new(robot, table, output) }

  describe "#execute" do
    context "when robot is placed" do
      before do
        allow(robot).to receive(:placed?).and_return(true)
      end

      it "tells the robot to turn left" do
        expect(robot).to receive(:turn).with(:left)
        left_command.execute
      end
    end

    context "when robot is not placed" do
      before do
        allow(robot).to receive(:placed?).and_return(false)
      end

      it "does not tell the robot to turn left" do
        expect(robot).not_to receive(:turn)
        left_command.execute
      end

      it "does not raise any error" do
        expect { left_command.execute }.not_to raise_error
      end
    end
  end
end