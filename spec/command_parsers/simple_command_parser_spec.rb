require 'command_parsers/simple_command_parser'
require 'commands/move'
require 'commands/left'
require 'commands/right'
require 'commands/report'

RSpec.describe CommandParsers::SimpleCommandParser do
  let(:robot) { instance_double('Robot') }
  let(:table) { instance_double('Table') }
  let(:output) { instance_double('Output') }

  describe '.can_parse?' do
    context 'when input is a known simple command' do
      it 'returns true for MOVE' do
        expect(described_class.can_parse?('MOVE')).to be true
      end

      it 'returns true for LEFT' do
        expect(described_class.can_parse?('LEFT')).to be true
      end

      it 'returns true for RIGHT' do
        expect(described_class.can_parse?('RIGHT')).to be true
      end

      it 'returns true for REPORT' do
        expect(described_class.can_parse?('REPORT')).to be true
      end
    end

    context 'when input is not a known simple command' do
      it 'returns false for PLACE' do
        expect(described_class.can_parse?('PLACE 1,2,NORTH')).to be false
      end

      it 'returns false for an unknown command' do
        expect(described_class.can_parse?('JUMP')).to be false
      end

      it 'returns false for a partial command' do
        expect(described_class.can_parse?('MOV')).to be false
      end
    end
  end

  describe '.parse' do
    it 'returns a Commands::Move object for "MOVE"' do
      command = described_class.parse('MOVE', robot, table, output)
      expect(command).to be_a(Commands::Move)
      expect(command.robot).to eq(robot)
      expect(command.table).to eq(table)
      expect(command.output).to eq(output)
    end

    it 'returns a Commands::Left object for "LEFT"' do
      command = described_class.parse('LEFT', robot, table, output)
      expect(command).to be_a(Commands::Left)
    end

    it 'returns a Commands::Right object for "RIGHT"' do
      command = described_class.parse('RIGHT', robot, table, output)
      expect(command).to be_a(Commands::Right)
    end

    it 'returns a Commands::Report object for "REPORT"' do
      command = described_class.parse('REPORT', robot, table, output)
      expect(command).to be_a(Commands::Report)
    end

    it 'does not implicitly handle invalid commands (it expects can_parse? to filter first)' do
      expect { described_class.parse('INVALID_COMMAND', robot, table, output) }.to raise_error(NoMethodError)
    end
  end
end