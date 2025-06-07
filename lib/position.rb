class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    other.is_a?(Position) && x == other.x && y == other.y
  end

  def to_s
    "#{x},#{y}"
  end
end