class ToyRobotSimulator
  def initialize(output = $stdout)
    @output = output
    @placed = false
    @moved_once = false
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
      @moved_once = false
    elsif !@placed
      return
    elsif command == 'MOVE' && !@moved_once
      move
      @moved_once = true
    elsif command == 'LEFT'
      turn_left
    elsif command == 'REPORT'
      @output.puts "#{@x},#{@y},#{@direction}"
    end
  end

  def move
    case @direction
    when 'NORTH' then @y += 1
    end
  end

  def turn_left
    @direction = 'WEST' if @direction == 'NORTH'
  end
end
