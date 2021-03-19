require 'optparse'
require_relative 'rtl'

if RTL.ffmpeg?
  puts "Using ffmpeg version: #{RTL.ffmpeg_version}"
else
  puts 'Error: ffpmeg is not installed on this system. Please install the necessary packages before you continue.'
  exit
end

ARGV << '-h' if ARGV.empty?

@options = {
  quality: '1280x720',
  verbose: false,
  target: __dir__
}

OptionParser.new do |opts|
  opts.banner = 'Usage: ruby dl.rb <URL> [options]'
  opts.on('-1', '--low', 'Low quality (640x360)') do |v| @options[:quality] = '640x360' end
  opts.on('-2', '--average', 'Average quality (854x480)') do |v| @options[:quality] = '854x480' end
  opts.on('-3', '--high', 'High quality (1280x720)') do |v| @options[:quality] = '1280x720' end
  opts.on('-4', '--highest', 'Highest quality (1920x1080)') do |v| @options[:quality] = '1920x1080' end
  opts.on('-v', '--verbose', 'Verbose mode') do |v| @options[:verbose] = true end
  opts.on('-o', '--output=FOLDER', 'Specify output folder (optional)') do |v| @options[:target] = v end
  opts.on_tail('-h', '--help', 'Show help message') do
    puts opts
    exit
  end
end.parse!

ARGV.each do |url|
  RTL.parse(url, @options)
end
