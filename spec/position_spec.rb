require 'position'

RSpec.describe Position do
  describe '#initialize' do
    it 'creates a Position object with the given x and y coordinates' do
      position = Position.new(10, 20)
      expect(position).to be_an_instance_of(Position)
      expect(position.x).to eq(10)
      expect(position.y).to eq(20)
    end
  end

  describe '#x' do
    it 'returns the x coordinate' do
      position = Position.new(5, 7)
      expect(position.x).to eq(5)
    end
  end

  describe '#y' do
    it 'returns the y coordinate' do
      position = Position.new(5, 7)
      expect(position.y).to eq(7)
    end
  end

  describe '#==' do
    context 'when comparing with another Position object' do
      it 'returns true if x and y coordinates are the same' do
        pos1 = Position.new(1, 2)
        pos2 = Position.new(1, 2)
        expect(pos1 == pos2).to be true
      end

      it 'returns false if x coordinates are different' do
        pos1 = Position.new(1, 2)
        pos2 = Position.new(3, 2)
        expect(pos1 == pos2).to be false
      end

      it 'returns false if y coordinates are different' do
        pos1 = Position.new(1, 2)
        pos2 = Position.new(1, 4)
        expect(pos1 == pos2).to be false
      end

      it 'returns false if both x and y coordinates are different' do
        pos1 = Position.new(1, 2)
        pos2 = Position.new(3, 4)
        expect(pos1 == pos2).to be false
      end
    end

    context 'when comparing with an object of a different class' do
      it 'returns false' do
        pos = Position.new(1, 2)
        expect(pos == [1, 2]).to be false
        expect(pos == {x: 1, y: 2}).to be false
        expect(pos == '1,2').to be false
      end
    end
  end

  describe '#to_s' do
    it 'returns a string representation in "x,y" format' do
      position = Position.new(100, 200)
      expect(position.to_s).to eq('100,200')
    end

    it 'handles negative coordinates correctly' do
      position = Position.new(-5, -10)
      expect(position.to_s).to eq('-5,-10')
    end

    it 'handles zero coordinates correctly' do
      position = Position.new(0, 0)
      expect(position.to_s).to eq('0,0')
    end
  end
end
