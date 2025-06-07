require_relative 'base'

module Commands
  class Left < Base
    def execute
      return unless robot_placed?
      robot.turn_left
    end
  end
end