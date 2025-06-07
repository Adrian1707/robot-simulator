# frozen_string_literal: true

require 'toy_robot_simulator'

RSpec.describe 'Toy Robot Simulator End-to-End Integration' do
  let(:output_buffer) { StringIO.new }
  let(:simulator) { ToyRobotSimulator.new(output_buffer) }

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

    it 'handles turning and reports correctly (Example B)' do
      commands = <<~COMMANDS
        PLACE 0,0,NORTH
        LEFT
        REPORT
      COMMANDS
      expect(run_commands(commands)).to eq('0,0,WEST')
    end
  end
end