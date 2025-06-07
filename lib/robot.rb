class Robot
  attr_reader :position, :direction

  def initialize
    @position = nil
    @direction = nil
    @placed = false
  end

  def place(position, direction)
    @position = position
    @direction = direction
    @placed = true
  end

  def move(new_position)
    @position = new_position
  end

  def turn(direction)
    return nil unless placed?

    @direction = @direction.turn(direction)
  end

  def report
    return nil unless placed?

    "#{position},#{direction}"
  end

  def placed?
    @placed
  end

  def next_position
    return nil unless placed?

    delta_x, delta_y = direction.coordinate_delta
    Position.new(position.x + delta_x, position.y + delta_y)
  end
end