dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + "/../lib"

require "test/unit"
require "midi"

module TestHelper
  
  def self.select_devices
    $test_device ||= {}
    { :input => UniMIDI::Input.all, :output => UniMIDI::Output.all }.each do |type, devs|
      puts ""
      puts "select an #{type.to_s}..."
      while $test_device[type].nil?
        devs.each do |device|
          puts device.pretty_name
        end
        selection = $stdin.gets.chomp
        if selection != ""
          selection = selection.to_i
          $test_device[type] = devs.find { |d| d.id == selection }
          puts "selected #{selection} for #{type.to_s}" unless $test_device[type]
        end
      end
    end
  end 
     
end

TestHelper.select_devices
