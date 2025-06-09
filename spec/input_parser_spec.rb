require 'input_parser'

RSpec.describe InputParser do
  describe '.parse' do
    context 'when a valid PLACE command is given' do
      it 'returns a Commands::Place object' do
        command = described_class.parse('PLACE 0,0,NORTH')
        expect(command[:command_class]).to eq(Commands::Place)
        expect(command[:command_args]).to eq([0, 0, "NORTH"])
      end

      it 'uses PlaceCommandParser to parse the command' do
        allow(CommandParsers::PlaceCommandParser).to receive(:can_parse?).and_return(true)
        expect(CommandParsers::PlaceCommandParser).to receive(:parse).with('PLACE 1,1,EAST').and_call_original

        described_class.parse('PLACE 1,1,EAST')
      end
    end

    context 'when a valid simple command is given' do
      it 'returns a Commands::Move object for "MOVE"' do
        command = described_class.parse('MOVE')
        expect(command[:command_class]).to eq(Commands::Move)
      end

      it 'uses SimpleCommandParser to parse the command' do
        allow(CommandParsers::PlaceCommandParser).to receive(:can_parse?).and_return(false)
        allow(CommandParsers::SimpleCommandParser).to receive(:can_parse?).and_return(true)
        expect(CommandParsers::SimpleCommandParser).to receive(:parse).with('LEFT').and_call_original

        described_class.parse('LEFT')
      end
    end

    context 'when an invalid or unknown command is given' do
      it 'returns a Commands::Invalid object' do
        command = described_class.parse('UNKNOWN_COMMAND')
        expect(command[:command_class]).to eq(Commands::Invalid)
      end

      it 'returns Commands::Invalid if no parser strategy can handle the input' do
        allow(CommandParsers::PlaceCommandParser).to receive(:can_parse?).and_return(false)
        allow(CommandParsers::SimpleCommandParser).to receive(:can_parse?).and_return(false)

        command = described_class.parse('FOOBAR')
        expect(command[:command_class]).to eq(Commands::Invalid)
      end

      it 'handles nil input gracefully' do
        command = described_class.parse(nil)
        expect(command[:command_class]).to eq(Commands::Invalid)
      end
    
      it 'handles empty string input' do
        command = described_class.parse('')
        expect(command[:command_class]).to eq(Commands::Invalid)
      end
    
      it 'handles whitespace-only input' do
        command = described_class.parse('   ')
        expect(command[:command_class]).to eq(Commands::Invalid)
      end
    end
  end
end
