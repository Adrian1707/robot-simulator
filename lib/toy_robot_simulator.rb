class Direction
  DIRECTIONS = ['NORTH', 'EAST', 'SOUTH', 'WEST']

  def initialize(name)
    @name = name
  end

  def turn_left
    idx = DIRECTIONS.index(@name)
    Direction.new(DIRECTIONS[(idx - 1) % 4])
  end

  def to_s
    @name
  end

  def movement_delta
    {
      'NORTH' => [0, 1],
      'EAST'  => [1, 0],
      'SOUTH' => [0, -1],
      'WEST'  => [-1, 0]
    }[@name]
  end
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
    dx, dy = @direction.movement_delta
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
    if command.start_with?('PLACE')
      x, y, dir = command.match(/PLACE (\d+),(\d+),(NORTH|SOUTH|EAST|WEST)/).captures
      @robot.place(x.to_i, y.to_i, dir)
    elsif !@robot.placed?
      return
    elsif command == 'MOVE'
      @robot.move
    elsif command == 'LEFT'
      @robot.turn_left
    elsif command == 'REPORT'
      @output.puts @robot.report
    end
  end
end