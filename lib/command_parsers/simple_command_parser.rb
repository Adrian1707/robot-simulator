require_relative './base'
require 'commands/move'
require 'commands/left'
require 'commands/right'
require 'commands/report'

module CommandParsers
  class SimpleCommandParser < Base
    COMMAND_MAP = {
      'MOVE' => Commands::Move,
      'LEFT' => Commands::Left,
      'RIGHT' => Commands::Right,
      'REPORT' => Commands::Report
    }.freeze

    def self.can_parse?(input)
      COMMAND_MAP.key?(input)
    end

    def self.parse(input, robot, table, output)
      COMMAND_MAP[input].new(robot, table, output)
    end
  end
end