class ToyRobotSimulator
  def initialize(output = $stdout)
    @output = output
    @placed = false
  end

  def run(input)
    input.each_line do |line|
      handle_command(line.strip)
    end
  end

  private

  def handle_command(command)
    if command.start_with?('PLACE')
      x, y, dir = command.match(/PLACE (\d+),(\d+),(NORTH|SOUTH|EAST|WEST)/).captures
      @x = x.to_i
      @y = y.to_i
      @direction = dir
      @placed = true
    elsif !@placed
      return
    elsif command == 'MOVE'
      move
    elsif command == 'LEFT'
      turn_left
    elsif command == 'REPORT'
      @output.puts "#{@x},#{@y},#{@direction}"
    end
  end

  def move
    case @direction
    when 'NORTH' then @y += 1
    when 'SOUTH' then @y -= 1
    when 'EAST'  then @x += 1
    when 'WEST'  then @x -= 1
    end
  end

  def turn_left
    directions = ['NORTH', 'WEST', 'SOUTH', 'EAST']
    idx = directions.index(@direction)
    @direction = directions[(idx + 1) % 4]
  end
end
