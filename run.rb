require_relative './lib/toy_robot_simulator'

def display_instructions
  puts "\n"
  puts "🤖 Welcome to the Toy Robot Simulator!".center(80)
  puts "-" * 80

  puts "\n📋  Available Commands:\n\n"

  puts "+----------------------+---------------------------------------------------------+"
  puts "| COMMAND              | DESCRIPTION                                             |"
  puts "+----------------------+---------------------------------------------------------+"
  puts "| PLACE X,Y,F         | 🚨 Required first! Places the robot on the board.        |"
  puts "|                     |   - X, Y: Position (0-4)                                 |"
  puts "|                     |   - F: Facing (NORTH, SOUTH, EAST, WEST)                |"
  puts "+----------------------+---------------------------------------------------------+"
  puts "| MOVE                | Moves the robot one unit forward in the current direction|"
  puts "+----------------------+---------------------------------------------------------+"
  puts "| LEFT                | Rotates the robot 90° to the left                       |"
  puts "+----------------------+---------------------------------------------------------+"
  puts "| RIGHT               | Rotates the robot 90° to the right                      |"
  puts "+----------------------+---------------------------------------------------------+"
  puts "| REPORT              | Displays the current position and direction of the robot|"
  puts "+----------------------+---------------------------------------------------------+"

  puts "\n🛑  Note: The first command **must** be a valid PLACE command, or all others will be ignored.".upcase
  puts "\n🧭  Table Coordinates: Origin (0,0) is at the **South-West** corner (bottom-left)."
  puts "\n🚪  Leave anytime by pressing Ctrl-d"
end

at_exit do
  puts "\n⭐️  Thanks for playing! If you enjoyed this game, feel free to offer a job to Adrian Booth"
end

if __FILE__ == $PROGRAM_NAME
  simulator = ToyRobotSimulator.new

  if ARGV.empty?
    # Interactive mode: read commands from standard input with prompt
    puts display_instructions
   
    loop do
      line = $stdin.gets
      break if line.nil?
      line.strip!
      next if line.empty?
      simulator.execute_command(line)
    end
  else
    # Read commands from files passed as arguments
    ARGV.each do |filename|
      begin
        File.open(filename, 'r') do |file|
          simulator.run(file)
        end
      rescue Errno::ENOENT
        puts "Error: File '#{filename}' not found"
      rescue Errno::EACCES
        puts "Error: Permission denied reading '#{filename}'"
      end
    end
  end
end
