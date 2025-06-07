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

class Table
  WIDTH = 5
  HEIGHT = 5

  def valid_position?(position)
    position.x.between?(0, WIDTH - 1) && position.y.between?(0, HEIGHT - 1)
  end
end

class Robot
  attr_reader :position, :direction

  def initialize
    @placed = false
    @table = Table.new
  end

  def place(x, y, direction)
    new_position = Position.new(x, y)
    return unless @table.valid_position?(new_position)

    @position = new_position
    @direction = Direction.new(direction)
    @placed = true
  end

  def placed?
    @placed
  end

  def move
    dx, dy = @direction.coordinate_delta
    new_position = Position.new(@position.x + dx, @position.y + dy)
    return unless @table.valid_position?(new_position)

    @position = new_position
  end

  def turn_left
    @direction = @direction.turn_left
  end

  def turn_right
    @direction = @direction.turn_right
  end

  def report
    "#{@position},#{@direction}"
  end
end


class ToyRobotSimulator
  def initialize(output = $stdout)
    @output = output
    @robot = Robot.new
  end

  def run(input)
    input.each_line do |line|
      handle_command(line.strip)
    end
  end

  private

  def handle_command(command)
    case command
    when /\APLACE (\d+),(\d+),(NORTH|EAST|SOUTH|WEST)\z/
      x, y, dir = $1.to_i, $2.to_i, $3
      @robot.place(x, y, dir)
    when 'MOVE'
      @robot.move if @robot.placed?
    when 'LEFT'
      @robot.turn_left if @robot.placed?
    when 'RIGHT'
      @robot.turn_right if @robot.placed?
    when 'REPORT'
      @output.puts @robot.report if @robot.placed?
    else
      # Ignore unsupported commands, maybe we might want to log or alert for these later
    end
  end
end