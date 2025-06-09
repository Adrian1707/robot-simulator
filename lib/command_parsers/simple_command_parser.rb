require_relative './base'
require_relative '../commands/move'
require_relative '../commands/left'
require_relative '../commands/right'
require_relative '../commands/report'

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

    def self.parse(input)
      # This isn't really needed given the check above, but I want the parse method to always return
      # consistent types and for the command_class to never be nil 
      return { command_class: Commands::Invalid, command_args: [] }  unless COMMAND_MAP[input]

      {
        command_class: COMMAND_MAP[input],
        command_args: []
      }
    end
  end
end
