require_relative 'base'
require_relative '../position'
require_relative '../direction'

module Commands
  class Place < Base
    attr_reader :x, :y, :direction_name

    def initialize(robot, table, output, x, y, direction_name)
      super(robot, table, output)
      @x = x
      @y = y
      @direction_name = direction_name
    end

    def execute
      position = Position.new(x, y)
      direction = Direction.new(direction_name)
      if table.valid_position?(position)
        robot.place(position, direction)
      end
    end
  end
end
