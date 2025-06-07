require_relative './table'
require_relative './robot'
require_relative './input_parser'

class ToyRobotSimulator
  def initialize(table = Table.new, output = $stdout)
    @table = table
    @robot = Robot.new
    @output = output
  end

  def execute_command(input)
    command_from_input(input).execute
  end

  def run(input_source = $stdin)
    input_source.each_line do |line|
      next if line.strip.empty?
      execute_command(line.strip)
    end
  end

  private

  def command_from_input(input)
    InputParser.parse(input, robot, table, output)
  end

  attr_reader :table, :robot, :output
end
