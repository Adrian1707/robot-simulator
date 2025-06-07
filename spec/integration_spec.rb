# frozen_string_literal: true

require 'toy_robot_simulator'

RSpec.describe 'Toy Robot Simulator End-to-End Integration' do
  let(:output_buffer) { StringIO.new }
  let(:simulator) { ToyRobotSimulator.new(Table.new, output_buffer) }

  def run_commands(commands_string)
    input_buffer = StringIO.new(commands_string)
    simulator.run(input_buffer)
    output_buffer.string.strip 
  end

  context 'Basic movements and reporting' do
    it 'handles a simple movement and reports correctly (Example A)' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,1,NORTH')
    end

    it 'handles turning left and reports correctly (Example B)' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        LEFT
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,0,WEST')
    end

    it 'handles turning right and reports correctly' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        RIGHT
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,0,EAST')
    end

    it 'handles a sequence of movements and turns (Example C)' do
      commands = <<~COMMANDS
        PLACE 1,2,EAST
        MOVE
        MOVE
        LEFT
        MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('3,3,NORTH')
    end
  end

  context 'when robot is not yet placed' do
    it 'ignores move, turn, and report commands' do
      commands = <<~COMMANDS
        MOVE
        LEFT
        RIGHT
        REPORT
        PLACE 1,1,SOUTH
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('1,1,SOUTH')
    end
  end

  context 'preventing the robot from falling' do
    it 'ignores MOVE commands that would make it fall off the north edge' do
      commands = <<~COMMANDS
        PLACE 0,4,NORTH
        MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,4,NORTH')
    end

    it 'ignores MOVE commands that would make it fall off the east edge' do
      commands = <<~COMMANDS
        PLACE 4,0,EAST
        MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('4,0,EAST')
    end

    it 'ignores MOVE commands that would make it fall off the south edge' do
      commands = <<~COMMANDS
        PLACE 2,0,SOUTH
        MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('2,0,SOUTH')
    end

    it 'ignores MOVE commands that would make it fall off the west edge' do
      commands = <<~COMMANDS
        PLACE 0,3,WEST
        MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,3,WEST')
    end

    it 'ignores an initial PLACE command that is outside the table' do
      commands = <<~COMMANDS
        PLACE 5,5,NORTH
        REPORT
      COMMANDS
      expect(run_commands(commands)).to be_empty
    end

    it 'ignores a subsequent PLACE command that is outside the table' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        PLACE 10,10,EAST
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,0,NORTH')
    end
  end

  context 'command parsing and robustness' do
    it 'is case-sensitive for commands and directions' do
      commands = <<~COMMANDS
        place 0,0,north
        move
        right
        report
      COMMANDS
      expect(run_commands(commands)).to eq('')
    end

    it 'prevents extra whitespace around and within commands' do
      commands = <<~COMMANDS
          PLACE  1, 2,  EAST  
          MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('')
    end

    it 'ignores unsupported commands' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        JUMP
        TELEPORT
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,0,NORTH')
    end

    it 'ignores malformed PLACE commands' do
      commands = <<~COMMANDS
        PLACE 1,1,NORTH
        PLACE 1,NORTH
        PLACE A,B,C
        PLACE 1,1,UPWARDS
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('1,1,NORTH')
    end
  end

  context 'robot state management' do
    it 'can be re-placed on the table, resetting its position and direction' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        MOVE
        PLACE 3,3,SOUTH
        MOVE
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('3,2,SOUTH')
    end

    it 'reports the correct state after each command in a sequence' do
      commands = <<~COMMANDS
        PLACE 1,1,EAST
        REPORT
        MOVE
        REPORT
        LEFT
        REPORT
      COMMANDS
      expected_output = "1,1,EAST\n2,1,EAST\n2,1,NORTH"
      expect(run_commands(commands)).to eq(expected_output)
    end

    it 'returns to the original direction after four left turns' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        LEFT
        LEFT
        LEFT
        LEFT
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,0,NORTH')
    end

    it 'returns to the original direction after four right turns' do
      commands = <<~COMMANDS
        PLACE 2,2,EAST
        RIGHT
        RIGHT
        RIGHT
        RIGHT
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('2,2,EAST')
    end
  end
end