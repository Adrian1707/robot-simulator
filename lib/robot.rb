class Robot
  def initialize
    @position = nil
    @direction = nil
  end

  def place(position, direction)
    return unless position && direction

    @position = position
    @direction = direction
  end

  def move(new_position)
    return unless placed?

    @position = new_position
  end

  def turn(direction)
    return unless placed?

    @direction = @direction.turn(direction)
  end

  def report
    return unless placed?

    "#{position},#{direction}"
  end

  def placed?
    !position.nil?
  end

  def next_position
    return unless placed?

    delta_x, delta_y = direction.coordinate_delta
    Position.new(position.x + delta_x, position.y + delta_y)
  end

  private

  attr_reader :position, :direction
end