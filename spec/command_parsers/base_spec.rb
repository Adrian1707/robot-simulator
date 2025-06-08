require 'command_parsers/base'

RSpec.describe CommandParsers::Base do
  let(:robot) { instance_double('Robot') }
  let(:table) { instance_double('Table') }
  let(:output) { instance_double('Output') }

  describe '.can_parse?' do
    it 'raises NotImplementedError' do
      expect { described_class.can_parse?('ANY_INPUT') }.to raise_error(NotImplementedError)
    end
  end

  describe '.parse' do
    it 'raises NotImplementedError' do
      expect { described_class.parse('ANY_INPUT') }.to raise_error(NotImplementedError)
    end
  end
end