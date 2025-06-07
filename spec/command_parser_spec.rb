require 'command_parser'

module Commands
  class Place; end
  class Move; end
  class Left; end
  class Right; end
  class Report; end
  class Invalid; end
end

RSpec.describe CommandParser do
  let(:robot) { double('Robot') }
  let(:table) { double('Table') }
  let(:output) { double('Output') }

  describe '.parse' do
    context 'when given a valid PLACE command' do
      it 'returns a Commands::Place object for "PLACE X,Y,DIRECTION"' do
        command = CommandParser.parse('PLACE 0,0,NORTH', robot, table, output)
        expect(command).to be_a(Commands::Place)
      end

      it 'returns a Commands::Invalid object for "PLACE 1,2,SOUTH" with varied spacing' do
        command = CommandParser.parse('  PLACE 1,2, SOUTH  ', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'is case-sensitive for the direction part of PLACE' do
        command = CommandParser.parse('PLACE 3,4,west', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end
    end

    context 'when given an invalid PLACE command format' do
      it 'returns a Commands::Invalid object for "PLACE"' do
        command = CommandParser.parse('PLACE', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for "PLACE 0,0"' do
        command = CommandParser.parse('PLACE 0,0', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for "PLACE 0,0,INVALID"' do
        command = CommandParser.parse('PLACE 0,0,INVALID', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for malformed PLACE commands' do
        command = CommandParser.parse('PLACE 0,0', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for "PLACE INVALID_FORMAT"' do
        command = CommandParser.parse('PLACE INVALID_FORMAT', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end
    end

    context 'when given a valid simple command' do
      it 'returns a Commands::Move object for "MOVE"' do
        command = CommandParser.parse('MOVE', robot, table, output)
        expect(command).to be_a(Commands::Move)
      end

      it 'returns a Commands::Left object for "LEFT"' do
        command = CommandParser.parse('LEFT', robot, table, output)
        expect(command).to be_a(Commands::Left)
      end

      it 'returns a Commands::Right object for "RIGHT"' do
        command = CommandParser.parse('RIGHT', robot, table, output)
        expect(command).to be_a(Commands::Right)
      end

      it 'returns a Commands::Report object for "REPORT"' do
        command = CommandParser.parse('REPORT', robot, table, output)
        expect(command).to be_a(Commands::Report)
      end

      it 'returns a Commands::Invalid object for leading/trailing whitespace for "MOVE"' do
        command = CommandParser.parse('  MOVE  ', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end
    end

    context 'when given an unknown or invalid command' do
      it 'returns a Commands::Invalid object for "JUMP"' do
        command = CommandParser.parse('JUMP', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for an empty string' do
        command = CommandParser.parse('', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for a command with invalid casing' do
        command = CommandParser.parse('move', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end

      it 'returns a Commands::Invalid object for random string' do
        command = CommandParser.parse('some random input', robot, table, output)
        expect(command).to be_a(Commands::Invalid)
      end
    end
  end
end
