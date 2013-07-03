require_relative "spec_helper"

describe FileExporter do

  it "should respond to ping" do
    FileExporter.instance.ping.should eq('pong')
  end

end
