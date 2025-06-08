require_relative './table'
require_relative './robot'
require_relative './input_parser'

class ToyRobotSimulator
  def initialize(table = Table.new, output = $stdout)
    @table = table
    @robot = Robot.new
    @output = output
  end

  def run(input_source = $stdin)
    input_source.each_line do |line|
      next if line.strip.empty?
      execute_command(line.strip)
    end
  end

  def execute_command(input)
    command_from_input(input).execute
  end

  private

  def command_from_input(input)
    parsed_command = InputParser.parse(input)
    command_class = parsed_command[:command_class]
    command_args = parsed_command[:command_args]

    command_class.new(robot, table, output, *command_args)
  end

  attr_reader :table, :robot, :output
end
