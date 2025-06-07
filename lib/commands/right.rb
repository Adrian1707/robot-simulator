require_relative 'base'

module Commands
  class Right < Base
    def execute
      return unless robot_placed?
      robot.turn_right
    end
  end
end