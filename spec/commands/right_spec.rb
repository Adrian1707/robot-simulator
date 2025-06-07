require 'commands/right'

RSpec.describe Commands::Right do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:right_command) { Commands::Right.new(robot, table, output) }

  describe "#execute" do
    context "when robot is placed" do
      before do
        allow(robot).to receive(:placed?).and_return(true)
      end

      it "tells the robot to turn right" do
        expect(robot).to receive(:turn).with(:right)
        right_command.execute
      end
    end

    context "when robot is not placed" do
      before do
        allow(robot).to receive(:placed?).and_return(false)
      end

      it "does not tell the robot to turn right" do
        expect(robot).not_to receive(:turn)
        right_command.execute
      end

      it "does not raise any error" do
        expect { right_command.execute }.not_to raise_error
      end
    end
  end
end
