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

  def turn_left
    @direction = @direction.turn_left
  end

  def turn_right
    @direction = @direction.turn_right
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


module Commands
  class Base
    attr_reader :robot, :table, :output

    def initialize(robot, table, output)
      @robot = robot
      @table = table
      @output = output
    end

    def execute
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def robot_placed?
      robot.placed?
    end
  end

  class Invalid < Base
    def execute
      # Do nothing for now, requiremments state just to ignore
    end
  end

  class Left < Base
    def execute
      return unless robot_placed?
      robot.turn_left
    end
  end

  class Move < Base
    def execute
      return unless robot_placed?

      next_position = robot.next_position
      if next_position && table.valid_position?(next_position)
        robot.move(next_position)
      end
    end
  end

  class Place < Base
    attr_reader :x, :y, :direction_name

    def initialize(robot, table, output, x, y, direction_name)
      super(robot, table, output)
      @x = x
      @y = y
      @direction_name = direction_name
    end

    def execute
      position = Position.new(x, y)
      begin
        direction = Direction.new(direction_name)
        if table.valid_position?(position)
          robot.place(position, direction)
        end
      end
    end
  end

  class Report < Base
    def execute
      return unless robot_placed?
      output.puts robot.report
    end
  end

  class Right < Base
    def execute
      return unless robot_placed?
      robot.turn_right
    end
  end
end

class CommandParser
  PLACE_PATTERN = /\APLACE\s+(\d+),(\d+),\s*(NORTH|SOUTH|EAST|WEST)\s*\z/i
  VALID_COMMANDS = {
    'MOVE' => Commands::Move,
    'LEFT' => Commands::Left,
    'RIGHT' => Commands::Right,
    'REPORT' => Commands::Report
  }.freeze

  def self.parse(input, robot, table, output)
    command_str = input.strip

    if command_str.start_with?('PLACE')
      parse_place_command(command_str, robot, table, output)
    elsif VALID_COMMANDS.key?(command_str)
      VALID_COMMANDS[command_str].new(robot, table, output)
    else
      Commands::Invalid.new(robot, table, output)
    end
  end

  private_class_method def self.parse_place_command(command_str, robot, table, output)
    match = PLACE_PATTERN.match(command_str)
    return Commands::Invalid.new(robot, table, output) unless match

    x, y, direction = match.captures
    Commands::Place.new(robot, table, output, x.to_i, y.to_i, direction)
  end
end

class ToyRobotSimulator
  def initialize(table = Table.new, output = $stdout)
    @table = table
    @robot = Robot.new
    @output = output
  end

  def execute_command(input)
    command = CommandParser.parse(input, robot, table, output)
    command.execute
  end

  def run(input_source = $stdin)
    input_source.each_line do |line|
      next if line.strip.empty?
      execute_command(line)
    end
  end

  private

  attr_reader :table, :robot, :output
end 