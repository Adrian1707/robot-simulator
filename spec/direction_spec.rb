require 'direction' 

RSpec.describe Direction do
  def direction(name)
    Direction.new(name)
  end

  describe '#initialize' do
    it 'initializes with the correct name' do
      north = direction('NORTH')
      expect(north.name).to eq('NORTH')

      east = direction('EAST')
      expect(east.name).to eq('EAST')
    end
  end

  describe '#turn' do
    context 'when turning right' do
      it 'turns NORTH to EAST' do
        north = direction('NORTH')
        expect(north.turn(:right).name).to eq('EAST')
      end

      it 'turns EAST to SOUTH' do
        east = direction('EAST')
        expect(east.turn(:right).name).to eq('SOUTH')
      end

      it 'turns SOUTH to WEST' do
        south = direction('SOUTH')
        expect(south.turn(:right).name).to eq('WEST')
      end

      it 'turns WEST to NORTH (wraps around)' do
        west = direction('WEST')
        expect(west.turn(:right).name).to eq('NORTH')
      end

      it 'returns a new Direction object' do
        north = direction('NORTH')
        new_direction = north.turn(:right)
        expect(new_direction).not_to be(north)
        expect(new_direction).to be_a(Direction)
      end
    end

    context 'when turning left' do
      it 'turns NORTH to WEST (wraps around)' do
        north = direction('NORTH')
        expect(north.turn(:left).name).to eq('WEST')
      end

      it 'turns WEST to SOUTH' do
        west = direction('WEST')
        expect(west.turn(:left).name).to eq('SOUTH')
      end

      it 'turns SOUTH to EAST' do
        south = direction('SOUTH')
        expect(south.turn(:left).name).to eq('EAST')
      end

      it 'turns EAST to NORTH' do
        east = direction('EAST')
        expect(east.turn(:left).name).to eq('NORTH')
      end

      it 'returns a new Direction object' do
        north = direction('NORTH')
        new_direction = north.turn(:left)
        expect(new_direction).not_to be(north)
        expect(new_direction).to be_a(Direction)
      end
    end
  end

  describe '#coordinate_delta' do
    it 'returns the correct delta for NORTH' do
      north = direction('NORTH')
      expect(north.coordinate_delta).to eq([0, 1])
    end

    it 'returns the correct delta for EAST' do
      east = direction('EAST')
      expect(east.coordinate_delta).to eq([1, 0])
    end

    it 'returns the correct delta for SOUTH' do
      south = direction('SOUTH')
      expect(south.coordinate_delta).to eq([0, -1])
    end

    it 'returns the correct delta for WEST' do
      west = direction('WEST')
      expect(west.coordinate_delta).to eq([-1, 0])
    end
  end

  describe '#to_s' do
    it 'returns the name of the direction as a string' do
      north = direction('NORTH')
      expect(north.to_s).to eq('NORTH')
      expect(north.to_s).to be_a(String)
    end
  end

  describe '#name' do
    it 'has a readable name attribute' do
      north = direction('NORTH')
      expect(north.name).to eq('NORTH')
    end
  end
end