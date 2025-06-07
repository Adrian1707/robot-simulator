require_relative './command_parsers/place_command_parser'
require_relative './command_parsers/simple_command_parser'
require_relative './commands/invalid'

class InputParser
  PARSER_STRATEGIES = [
    CommandParsers::PlaceCommandParser,
    CommandParsers::SimpleCommandParser
  ].freeze

  def self.parse(input, robot, table, output)
    command_str = input

    PARSER_STRATEGIES.each do |parser_strategy|
      if parser_strategy.can_parse?(command_str)
        return parser_strategy.parse(command_str, robot, table, output)
      end
    end

    Commands::Invalid.new(robot, table, output)
  end
end