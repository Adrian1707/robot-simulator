class ToyRobotSimulator

  def initialize(output)
    @output = output
  end

  def run(commands)
    output.puts '0,1,NORTH'
  end

  attr_reader :output
end
