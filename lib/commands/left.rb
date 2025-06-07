require_relative 'base'

module Commands
  class Left < Base
    def execute
      return unless robot_placed?
      robot.turn(:left)
    end
  end
end