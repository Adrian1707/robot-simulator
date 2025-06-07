class Table
  DEFAULT_SIZE = 5

  def initialize(width = DEFAULT_SIZE, height = DEFAULT_SIZE)
    @width = width
    @height = height
  end

  def valid_position?(position)
    position.x.between?(0, width - 1) && position.y.between?(0, height - 1)
  end

  private

  attr_reader :width, :height
end