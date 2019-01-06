#!/usr/bin/env ruby

$LOAD_PATH << File.dirname(__FILE__) + "/../lib/"

require 'extract'

def usage
  puts "USAGE: #{File.basename(__FILE__)} <input.html> <output.md>"
end

if ARGV.size != 2
  usage
  exit(1)
end


(input_file, output_file) = ARGV

begin
  input_data = File.read(input_file)
rescue Errno::ENOENT => e
  puts e
  exit(1)
end

File.open(output_file, 'w') do |output_handle|
  output_handle.write(extract(input_data).mediawiki)
end
