require_relative 'base'

module Commands
  class Move < Base
    def execute
      return unless robot_placed?

      next_position = robot.next_position
      if next_position && table.valid_position?(next_position)
        robot.move(next_position)
      end
    end
  end
end
