require_relative 'base'

module Commands
  class Report < Base
    def execute
      return unless robot_placed?
      output.puts robot.report
    end
  end
end 