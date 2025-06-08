class Direction
  COORDINATE_DELTAS = {
    'NORTH' => [0, 1],
    'EAST'  => [1, 0],
    'SOUTH' => [0, -1],
    'WEST'  => [-1, 0]
  }.freeze

  DIRECTION_NAMES = COORDINATE_DELTAS.keys.freeze
  ROTATION_STEPS = { left: -1, right: 1 }.freeze

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def turn(direction)
    Direction.new(rotated_direction_name(direction))
  end

  def coordinate_delta
    COORDINATE_DELTAS[name]
  end

  def to_s
    @name
  end

  private

  def rotated_direction_name(rotation)
    steps = ROTATION_STEPS.fetch(rotation) 
    new_index = (current_direction_index + steps) % DIRECTION_NAMES.length

    DIRECTION_NAMES[new_index]
  end

  def current_direction_index
    DIRECTION_NAMES.index(@name)
  end
end