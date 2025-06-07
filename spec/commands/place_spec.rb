require 'commands/place'
require 'position'
require 'direction'

RSpec.describe Commands::Place do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:x) { 0 }
  let(:y) { 0 }
  let(:direction_name) { :north }
  let(:place_command) { Commands::Place.new(robot, table, output, x, y, direction_name) }
  let(:expected_position) { Position.new(x, y) }
  let(:expected_direction) { Direction.new(direction_name) }

  describe "#initialize" do
    it "assigns a direction_name" do
      expect(place_command).not_to be_nil
    end
  end

  describe "#execute" do
    context "when the position is valid on the table" do
      before do
        allow(table).to receive(:valid_position?).with(expected_position).and_return(true)
      end

      it "tells the robot to place at the given position and direction" do
        expect(robot).to receive(:place).with(
          an_instance_of(Position).and(have_attributes(x: x, y: y)),
          an_instance_of(Direction).and(have_attributes(name: direction_name))
        )
        place_command.execute
      end
    end

    context "when the position is invalid on the table" do
      before do
        allow(table).to receive(:valid_position?).with(expected_position).and_return(false)
      end

      it "does not tell the robot to place" do
        expect(robot).not_to receive(:place)
        place_command.execute
      end
    end
  end
end
