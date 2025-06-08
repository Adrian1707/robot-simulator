require_relative './base'
require_relative '../commands/place'
require_relative '../commands/invalid'

module CommandParsers
  class PlaceCommandParser < Base
    # WARNING: This Regex will currently only work for tables up to 9x9
    # This is currently structured to prevent commands like PLACE 1,00,NORTH
    # Look into adapting or changing this for larger tables
    PLACE_PATTERN = /\APLACE\s+(\d{1}),(\d{1}),(NORTH|SOUTH|EAST|WEST)\z/

    def self.can_parse?(input)
      input.start_with?('PLACE')
    end

    def self.parse(input)
      match = PLACE_PATTERN.match(input)
      return { command_class: Commands::Invalid, command_args: [] } unless match

      x, y, direction = match.captures
      {
        command_class: Commands::Place,
        command_args: [x.to_i, y.to_i, direction]
      }
    end
  end
end
