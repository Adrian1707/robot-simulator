require 'position'
require 'direction'
require 'robot'

RSpec.describe Robot do
  let(:initial_position) { Position.new(0, 0) }

  let(:north_direction) do
    instance_double("Direction", name: "NORTH", to_s: "NORTH").tap do |direction|
      allow(direction).to receive(:coordinate_delta).and_return([0, 1])
    end
  end

  let(:east_direction) do
    instance_double("Direction", name: "EAST", to_s: "EAST").tap do |direction|
      allow(direction).to receive(:coordinate_delta).and_return([1, 0])
    end
  end

  let(:south_direction) do
    instance_double("Direction", name: "SOUTH", to_s: "SOUTH").tap do |direction|
      allow(direction).to receive(:coordinate_delta).and_return([0, -1])
    end
  end

  let(:west_direction) do
    instance_double("Direction", name: "WEST", to_s: "WEST").tap do |direction|
      allow(direction).to receive(:coordinate_delta).and_return([-1, 0])
    end
  end


  describe '#initialize' do
    it 'creates an unplaced robot' do
      robot = Robot.new
      expect(robot.position).to be_nil
      expect(robot.direction).to be_nil
      expect(robot.placed?).to be false
    end
  end

  describe '#place' do
    let(:robot) { Robot.new }

    it 'places the robot at the given position and direction' do
      robot.place(initial_position, north_direction)
      expect(robot.position).to eq(initial_position)
      expect(robot.direction).to eq(north_direction)
      expect(robot.placed?).to be true
    end

    it 'can re-place an already placed robot' do
      robot.place(initial_position, north_direction)
      new_position = Position.new(2, 2)
      robot.place(new_position, east_direction)
      expect(robot.position).to eq(new_position)
      expect(robot.direction).to eq(east_direction)
      expect(robot.placed?).to be true
    end
  end

  describe '#move' do
    let(:robot) { Robot.new }
    let(:new_position) { Position.new(0, 1) }

    context 'when robot is placed' do
      before do
        robot.place(initial_position, north_direction)
      end

      it 'updates the robots position to the new_position' do
        robot.move(new_position)
        expect(robot.position).to eq(new_position)
      end

      it 'does not change direction' do
        robot.move(new_position)
        expect(robot.direction).to eq(north_direction)
      end
    end

    context 'when robot is not placed' do
      it 'does not change position' do
        robot.move(new_position)
        expect(robot.position).to eq robot.position
      end
    end
  end

  describe '#turn' do
    let(:robot) { Robot.new }

    before do
      allow(north_direction).to receive(:turn).with(:left).and_return(west_direction)
      allow(north_direction).to receive(:turn).with(:right).and_return(east_direction)
    end

    context 'when robot is placed' do
      it 'updates the robots direction by turning left' do
        robot.place(initial_position, north_direction)
        robot.turn(:left)
        expect(robot.direction).to eq(west_direction)
      end

      it 'updates the robots direction by turning right' do
        robot.place(initial_position, north_direction)
        robot.turn(:right)
        expect(robot.direction).to eq(east_direction)
      end
    end

    context 'when robot is not placed' do
      it 'returns nil' do
        robot.turn(:left)
        expect(robot.direction).to be_nil
      end
    end
  end

  describe '#report' do
    let(:robot) { Robot.new }

    context 'when robot is placed' do
      it 'returns a string with position and direction' do
        robot.place(Position.new(1, 2), east_direction)
        expect(robot.report).to eq("1,2,EAST")
      end
    end

    context 'when robot is not placed' do
      it 'returns nil' do
        expect(robot.report).to be_nil
      end
    end
  end

  describe '#placed?' do
    it 'returns false when the robot is initialized' do
      robot = Robot.new
      expect(robot.placed?).to be false
    end

    it 'returns true after the robot is placed' do
      robot = Robot.new
      robot.place(initial_position, north_direction)
      expect(robot.placed?).to be true
    end
  end

  describe '#next_position' do
    let(:robot) { Robot.new }

    context 'when robot is placed' do
      it 'returns the correct next position when facing NORTH' do
        robot.place(Position.new(0, 0), north_direction)
        expect(robot.next_position).to eq(Position.new(0, 1))
      end

      it 'returns the correct next position when facing EAST' do
        robot.place(Position.new(0, 0), east_direction)
        expect(robot.next_position).to eq(Position.new(1, 0))
      end

      it 'returns the correct next position when facing SOUTH' do
        robot.place(Position.new(1, 1), south_direction)
        expect(robot.next_position).to eq(Position.new(1, 0))
      end

      it 'returns the correct next position when facing WEST' do
        robot.place(Position.new(1, 1), west_direction)
        expect(robot.next_position).to eq(Position.new(0, 1))
      end
    end

    context 'when robot is not placed' do
      it 'returns nil' do
        expect(robot.next_position).to be_nil
      end
    end
  end
end