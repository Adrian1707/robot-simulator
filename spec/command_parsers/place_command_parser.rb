require 'command_parsers/place_command_parser'
require 'commands/invalid'

RSpec.describe CommandParsers::PlaceCommandParser do
  let(:robot) { instance_double('Robot') }
  let(:table) { instance_double('Table') }
  let(:output) { instance_double('Output') }

  describe '.can_parse?' do
    context 'when input starts with PLACE' do
      it 'returns true for a valid PLACE command' do
        expect(described_class.can_parse?('PLACE 0,0,NORTH')).to be true
      end

      it 'returns true even if PLACE command is malformed but starts with "PLACE"' do
        expect(described_class.can_parse?('PLACE_INVALID')).to be true
      end
    end

    context 'when input does not start with PLACE' do
      it 'returns false for MOVE' do
        expect(described_class.can_parse?('MOVE')).to be false
      end

      it 'returns false for other commands' do
        expect(described_class.can_parse?('REPORT')).to be false
      end

      it 'returns false for arbitrary strings' do
        expect(described_class.can_parse?('HELLO WORLD')).to be false
      end
    end
  end

  describe '.parse' do
    context 'with a valid PLACE command' do
      it 'returns a Commands::Place object with correct attributes for NORTH' do
        command = described_class.parse('PLACE 1,2,NORTH', robot, table, output)
        expect(command).to be_a(Commands::Place)
        expect(command.x).to eq(1)
        expect(command.y).to eq(2)
        expect(command.direction).to eq('NORTH')
        expect(command.robot).to eq(robot)
        expect(command.table).to eq(table)
        expect(command.output).to eq(output)
      end

      it 'returns a Commands::Place object with correct attributes for WEST' do
        command = described_class.parse('PLACE 4,0,WEST', robot, table, output)
        expect(command).to be_a(Commands::Place)
        expect(command.x).to eq(4)
        expect(command.y).to eq(0)
        expect(command.direction).to eq('WEST')
      end
    end

    context 'with an invalid PLACE command format' do
      it 'returns a Commands::Invalid object for missing coordinates' do
        command = described_class.parse('PLACE NORTH', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
        expect(command.robot).to eq(robot)
        expect(command.table).to eq(table)
        expect(command.output).to eq(output)
      end

      it 'returns a Commands::Invalid object for invalid direction' do
        command = described_class.parse('PLACE 1,2,UP', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for extra characters' do
        command = described_class.parse('PLACE 1,2,NORTH EXTRA', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for malformed input' do
        command = described_class.parse('PLACEX 1,2,NORTH', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end
    end
  end
end