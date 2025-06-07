class Direction
  COORDINATE_DELTAS = {
    'NORTH' => [0, 1],
    'EAST'  => [1, 0],
    'SOUTH' => [0, -1],
    'WEST'  => [-1, 0]
  }.freeze

  DIRECTION_NAMES = COORDINATE_DELTAS.keys.freeze

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def turn(direction)
    current_index = DIRECTION_NAMES.index(@name)
    offset = direction == :left ? -1 : 1
    new_direction = DIRECTION_NAMES[(current_index + offset) % DIRECTION_NAMES.length]
    Direction.new(new_direction)
  end

  def coordinate_delta
    COORDINATE_DELTAS[name]
  end

  def to_s
    @name
  end
end