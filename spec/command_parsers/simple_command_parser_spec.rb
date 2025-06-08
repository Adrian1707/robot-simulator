require 'command_parsers/simple_command_parser'
require 'commands/move'
require 'commands/left'
require 'commands/right'
require 'commands/report'

RSpec.describe CommandParsers::SimpleCommandParser do
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
      command = described_class.parse('MOVE')
      expect(command[:command_class]).to eq(Commands::Move)
    end

    it 'returns a Commands::Left object for "LEFT"' do
      command = described_class.parse('LEFT')
      expect(command[:command_class]).to eq(Commands::Left)
    end

    it 'returns a Commands::Right object for "RIGHT"' do
      command = described_class.parse('RIGHT')
      expect(command[:command_class]).to eq(Commands::Right)
    end

    it 'returns a Commands::Report object for "REPORT"' do
      command = described_class.parse('REPORT')
      expect(command[:command_class]).to eq(Commands::Report)
    end
  end
end