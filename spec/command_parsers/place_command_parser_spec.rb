require 'command_parsers/place_command_parser'

RSpec.describe CommandParsers::PlaceCommandParser do
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
        command = described_class.parse('PLACE 1,2,NORTH')
        expect(command[:command_class]).to eq(Commands::Place)
        expect(command[:command_args]).to eq([1, 2, "NORTH"])
      end

      it 'returns a Commands::Place object with correct attributes for WEST' do
        command = described_class.parse('PLACE 4,0,WEST')
        expect(command[:command_class]).to eq(Commands::Place)
        expect(command[:command_args]).to eq([4, 0, "WEST"])
      end
    end

    context 'with an invalid PLACE command format' do
      it 'returns a Commands::Invalid object for missing coordinates' do
        command = described_class.parse('PLACE NORTH')
        expect(command[:command_class]).to eq(Commands::Invalid)
        expect(command[:command_args]).to eq([])
      end

      it 'returns a Commands::Invalid object when extra zeros in coordinates' do
        command = described_class.parse('PLACE 1,00,NORTH')
        expect(command[:command_class]).to eq(Commands::Invalid)
        expect(command[:command_args]).to eq([])
      end

      it 'returns a Commands::Invalid object for invalid direction' do
        command = described_class.parse('PLACE 1,2,UP')
        expect(command[:command_class]).to eq(Commands::Invalid)
        expect(command[:command_args]).to eq([])
      end

      it 'returns a Commands::Invalid object for extra characters' do
        command = described_class.parse('PLACE 1,2,NORTH EXTRA')
        expect(command[:command_class]).to eq(Commands::Invalid)
        expect(command[:command_args]).to eq([])
      end

      it 'returns a Commands::Invalid object for malformed input' do
        command = described_class.parse('PLACEX 1,2,NORTH')
        expect(command[:command_class]).to eq(Commands::Invalid)
        expect(command[:command_args]).to eq([])
      end

      it 'returns a Commands::Invalid object for valid command with comma at the end' do
        command = described_class.parse('PLACE 1,2,NORTH,')
        expect(command[:command_class]).to eq(Commands::Invalid)
        expect(command[:command_args]).to eq([])
      end
    end
  end
end