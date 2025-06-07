module Commands
  class Base
    attr_reader :robot, :table, :output

    def initialize(robot, table, output)
      @robot = robot
      @table = table
      @output = output
    end

    def execute
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    private

    def robot_placed?
      robot.placed?
    end
  end
end