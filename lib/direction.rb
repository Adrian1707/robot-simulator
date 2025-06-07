class Direction
  COORDINATE_DELTAS = {
    'NORTH' => [0, 1],
    'EAST'  => [1, 0],
    'SOUTH' => [0, -1],
    'WEST'  => [-1, 0]
  }.freeze

  DIRECTION_NAMES = COORDINATE_DELTAS.keys.freeze

  def initialize(name)
    @name = name
  end

  def turn_left
    current_index = DIRECTION_NAMES.index(@name)
    new_direction = DIRECTION_NAMES[(current_index - 1) % DIRECTION_NAMES.length]
    Direction.new(new_direction)
  end

  def turn_right
    current_index = DIRECTION_NAMES.index(@name)
    new_direction = DIRECTION_NAMES[(current_index + 1) % DIRECTION_NAMES.length]
    Direction.new(new_direction)
  end

  def to_s
    @name
  end

  def coordinate_delta
    COORDINATE_DELTAS[name]
  end

  attr_reader :name
end