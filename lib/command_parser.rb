require_relative './commands/move'
require_relative './commands/left'
require_relative './commands/right'
require_relative './commands/place'
require_relative './commands/report'
require_relative './commands/invalid'

class CommandParser
  PLACE_PATTERN = /\APLACE\s+(\d+),(\d+),(NORTH|SOUTH|EAST|WEST)\z/
  VALID_COMMANDS = {
    'MOVE' => Commands::Move,
    'LEFT' => Commands::Left,
    'RIGHT' => Commands::Right,
    'REPORT' => Commands::Report
  }.freeze
  def self.parse(input, robot, table, output)
    command_str = input

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