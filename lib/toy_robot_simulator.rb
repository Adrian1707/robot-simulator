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
    idx = DIRECTION_NAMES.index(@name)
    Direction.new(DIRECTION_NAMES[(idx - 1) % DIRECTION_NAMES.length])
  end

  def to_s
    @name
  end

  def coordinate_delta
    COORDINATE_DELTAS[name]
  end

  attr_reader :name
end

class Table
  WIDTH = 5
  HEIGHT = 5

  def valid_position?(x, y)
    x.between?(0, WIDTH - 1) && y.between?(0, HEIGHT - 1)
  end
end


class Robot
  attr_reader :x, :y, :direction

  def initialize
    @placed = false
    @table = Table.new
  end

  def place(x, y, direction)
    return unless @table.valid_position?(x, y)
    @x = x
    @y = y
    @direction = Direction.new(direction)
    @placed = true
  end

  def placed?
    @placed
  end

  def move
    dx, dy = @direction.coordinate_delta
    new_x = @x + dx
    new_y = @y + dy
    return unless @table.valid_position?(new_x, new_y)

    @x = new_x
    @y = new_y
  end

  def turn_left
    @direction = @direction.turn_left
  end

  def report
    "#{@x},#{@y},#{@direction}"
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
    when 'REPORT'
      @output.puts @robot.report if @robot.placed?
    else
      # Ignore unsupported commands, maybe we might want to log or alert for these later
    end
  end
end