require 'input_parser'
require 'command_parsers/place_command_parser'
require 'command_parsers/simple_command_parser'

RSpec.describe InputParser do
  let(:robot) { instance_double('Robot') }
  let(:table) { instance_double('Table') }
  let(:output) { instance_double('Output') }

  describe '.parse' do
    context 'when a valid PLACE command is given' do
      it 'returns a Commands::Place object' do
        command = described_class.parse('PLACE 0,0,NORTH', robot, table, output)
        expect(command).to be_a(Commands::Place)
      end

      it 'uses PlaceCommandParser to parse the command' do
        allow(CommandParsers::PlaceCommandParser).to receive(:can_parse?).and_return(true)
        expect(CommandParsers::PlaceCommandParser).to receive(:parse).with('PLACE 1,1,EAST', robot, table, output).and_call_original

        described_class.parse('PLACE 1,1,EAST', robot, table, output)
      end
    end

    context 'when a valid simple command is given' do
      it 'returns a Commands::Move object for "MOVE"' do
        command = described_class.parse('MOVE', robot, table, output)
        expect(command).to be_a(Commands::Move)
      end

      it 'uses SimpleCommandParser to parse the command' do
        allow(CommandParsers::PlaceCommandParser).to receive(:can_parse?).and_return(false)
        allow(CommandParsers::SimpleCommandParser).to receive(:can_parse?).and_return(true)
        expect(CommandParsers::SimpleCommandParser).to receive(:parse).with('LEFT', robot, table, output).and_call_original

        described_class.parse('LEFT', robot, table, output)
      end
    end

    context 'when an invalid or unknown command is given' do
      it 'returns a Commands::Invalid object' do
        command = described_class.parse('UNKNOWN_COMMAND', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns Commands::Invalid if no parser strategy can handle the input' do
        allow(CommandParsers::PlaceCommandParser).to receive(:can_parse?).and_return(false)
        allow(CommandParsers::SimpleCommandParser).to receive(:can_parse?).and_return(false)

        command = described_class.parse('GARBAGE', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end
    end
  end
end
