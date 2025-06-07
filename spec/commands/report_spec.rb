require 'commands/report'

RSpec.describe Commands::Report do
  let(:robot) { instance_double("Robot") }
  let(:table) { instance_double("Table") }
  let(:output) { instance_double("Output") }
  let(:report_command) { Commands::Report.new(robot, table, output) }
  let(:robot_report_string) { "0,0,NORTH" }

  describe "#execute" do
    context "when robot is placed" do
      before do
        allow(robot).to receive(:placed?).and_return(true)
        allow(robot).to receive(:report).and_return(robot_report_string)
      end

      it "tells the output to puts the robot's report" do
        expect(output).to receive(:puts).with(robot_report_string)
        report_command.execute
      end
    end

    context "when robot is not placed" do
      before do
        allow(robot).to receive(:placed?).and_return(false)
      end

      it "does not interact with the robot or output regarding report" do
        expect(robot).not_to receive(:report)
        expect(output).not_to receive(:puts)
        report_command.execute
      end

      it "does not raise any error" do
        expect { report_command.execute }.not_to raise_error
      end
    end
  end
end
