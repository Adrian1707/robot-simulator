require_relative './base'
require_relative '../commands/place'
require_relative '../commands/invalid'

module CommandParsers
  class PlaceCommandParser < Base
    PLACE_PATTERN = /\APLACE\s+(\d+),(\d+),(NORTH|SOUTH|EAST|WEST)\z/

    def self.can_parse?(input)
      input.start_with?('PLACE')
    end

    def self.parse(input, robot, table, output)
      match = PLACE_PATTERN.match(input)
      return Commands::Invalid.new(robot, table, output) unless match

      x, y, direction = match.captures
      Commands::Place.new(robot, table, output, x.to_i, y.to_i, direction)
    end
  end
end