require 'table'

RSpec.describe Table do
  describe '#initialize' do
    context 'without arguments' do
      it 'creates a Table object' do
        table = Table.new
        expect(table).to be_an_instance_of(Table)
      end
    end

    context 'with custom arguments' do
      it 'creates a Table object' do
        table = Table.new(8, 6)
        expect(table).to be_an_instance_of(Table)
      end
    end
  end

  describe '#valid_position?' do
    let(:table_5x5) { Table.new } 
    let(:table_3x4) { Table.new(3, 4) }

    context 'for a 5x5 table (default)' do
      it 'returns true for a valid position (0,0)' do
        position = Position.new(0, 0)
        expect(table_5x5.valid_position?(position)).to be true
      end

      it 'returns true for a valid position (width-1, height-1)' do
        position = Position.new(4, 4) # 5x5 table has max index 4
        expect(table_5x5.valid_position?(position)).to be true
      end

      it 'returns true for a valid position in the middle' do
        position = Position.new(2, 3)
        expect(table_5x5.valid_position?(position)).to be true
      end

      it 'returns false for a position with negative x' do
        position = Position.new(-1, 0)
        expect(table_5x5.valid_position?(position)).to be false
      end

      it 'returns false for a position with negative y' do
        position = Position.new(0, -1)
        expect(table_5x5.valid_position?(position)).to be false
      end

      it 'returns false for a position with x greater than width-1' do
        position = Position.new(5, 0)
        expect(table_5x5.valid_position?(position)).to be false
      end

      it 'returns false for a position with y greater than height-1' do
        position = Position.new(0, 5)
        expect(table_5x5.valid_position?(position)).to be false
      end

      it 'returns false for a position with both coordinates out of bounds' do
        position = Position.new(5, 5)
        expect(table_5x5.valid_position?(position)).to be false
      end
    end

    context 'for a custom 3x4 table' do
      it 'returns true for a valid position (0,0)' do
        position = Position.new(0, 0)
        expect(table_3x4.valid_position?(position)).to be true
      end

      it 'returns true for a valid position (width-1, height-1)' do
        position = Position.new(2, 3) # 3x4 table has max index (2,3)
        expect(table_3x4.valid_position?(position)).to be true
      end

      it 'returns false for a position with x greater than width-1' do
        position = Position.new(3, 0)
        expect(table_3x4.valid_position?(position)).to be false
      end

      it 'returns false for a position with y greater than height-1' do
        position = Position.new(0, 4)
        expect(table_3x4.valid_position?(position)).to be false
      end
    end
  end
end
