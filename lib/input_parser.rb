require_relative './command_parsers/place_command_parser'
require_relative './command_parsers/simple_command_parser'
require_relative './commands/invalid'

class InputParser
  PARSER_STRATEGIES = [
    CommandParsers::PlaceCommandParser,
    CommandParsers::SimpleCommandParser
  ].freeze

  def self.parse(input)
    invalid_command = { command_class: Commands::Invalid, command_args: [] }
    return invalid_command if input.nil? || input.strip.empty?

    command_str = input

    PARSER_STRATEGIES.each do |parser_strategy|
      if parser_strategy.can_parse?(command_str)
        parsed_command = parser_strategy.parse(command_str)
        return parsed_command
      end
    end

    invalid_command
  end
end
