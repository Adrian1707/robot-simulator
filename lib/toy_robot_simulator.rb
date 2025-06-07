require_relative './table'
require_relative './robot'
require_relative './command_parser'

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
