require 'commands/move'

RSpec.describe Commands::Move do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:move_command) { Commands::Move.new(robot, table, output) }
  let(:next_position) { instance_double("Position") }

  before do
    allow(robot).to receive(:placed?).and_return(true)
  end

  describe "#execute" do
    context "when robot is placed" do
      before do
        allow(robot).to receive(:placed?).and_return(true)
        allow(robot).to receive(:next_position).and_return(next_position)
      end

      context "when the next position is valid" do
        before do
          allow(table).to receive(:valid_position?).with(next_position).and_return(true)
        end

        it "tells the robot to move to the next position" do
          expect(robot).to receive(:move).with(next_position)
          move_command.execute
        end
      end

      context "when the next position is invalid" do
        before do
          allow(table).to receive(:valid_position?).with(next_position).and_return(false)
        end

        it "does not tell the robot to move" do
          expect(robot).not_to receive(:move)
          move_command.execute
        end
      end

      context "when robot.next_position returns nil" do
        before do
          allow(robot).to receive(:next_position).and_return(nil)
        end

        it "does not tell the robot to move" do
          expect(robot).not_to receive(:move)
          expect(table).not_to receive(:valid_position?)
          move_command.execute
        end
      end
    end

    context "when robot is not placed" do
      before do
        allow(robot).to receive(:placed?).and_return(false)
      end

      it "does not interact with the robot or table regarding movement" do
        expect(robot).not_to receive(:next_position)
        expect(robot).not_to receive(:move)
        expect(table).not_to receive(:valid_position?)
        move_command.execute
      end

      it "does not raise any error" do
        expect { move_command.execute }.not_to raise_error
      end
    end
  end
end
