require 'optparse'
require 'open-uri'

ffmpeg = %x[ffmpeg -version]

if ffmpeg.nil?
  puts 'ERROR: ffpmeg is not installed on this system. Please install the necessary package(s) before you continue.'
  exit
else
  puts 'Using ffmpeg version: ' + ffmpeg.split("\n").first.match(/(?<=version n)(.*)(?= Copyright)/).to_s
end

ARGV << '-h' if ARGV.empty?
TMP_FOLDER = 'tmp/'
HTML_TAG = /<rtl-player(?:[^>]+hls=\"(.*?)\"[^>]*)?>/
HLS_MANIFEST = /(?:#EXT-X-STREAM-INF:)(?:BANDWIDTH=(?<BANDWIDTH>\d+),?|RESOLUTION=(?<RESOLUTION>\d+x\d+),?)*\n(?<FILE>[.\w]*)/m

# default options
options = {
  quality: '1280x720',
  verbose: false
}

OptionParser.new do |opts|
  opts.banner = 'Usage: ruby dl.rb <URL> [options]'
  opts.on('-1', '--low', 'Low quality (640x360)') do |v| options[:quality] = '640x360' end
  opts.on('-2', '--average', 'Average quality (854x480)') do |v| options[:quality] = '854x480' end
  opts.on('-3', '--high', 'High quality (1280x720)') do |v| options[:quality] = '1280x720' end
  opts.on('-4', '--highest', 'Highest quality (1920x1080)') do |v| options[:quality] = '1920x1080' end
  opts.on('-v', '--verbose', 'Verbose mode') do |v| options[:verbose] = true end
  opts.on_tail('-h', '--help', 'Show help message') do
    puts opts
    exit
  end
end.parse!

def fetch(url)
  URI.parse(url).read
end

def get_filename(url)
  File.basename(URI.parse(url).path)
end

def download(url, temp = true)
  data = fetch(url)
  open(TMP_FOLDER + get_filename(url), 'wb+') do |f|
    f.write(data)
  end
end

quality = options[:quality].to_s
puts "Selected video quality: #{quality}"

ARGV.each do |url|

  # fetch url
  puts "Parsing: #{url}"
  html = fetch(url)

  if (html =~ HTML_TAG)

    # extract playlist.m3u8 url from <rtl-player> tag
    playlist = html.scan(HTML_TAG)[0][0]
    puts "Found playlist: #{playlist}"

    # download playlist.m3u8
    hls = fetch(playlist)
    videos = hls.scan(HLS_MANIFEST)
    count = videos.size

    # select chunk file for selected quality
    videos.select! { |v| v[1].include? quality }
    chunk_file = videos[0][2]
    puts "Found chunk list: #{chunk_file} (#{quality}) - out of #{count} chunk list" + (count > 1 ? 's' : '')

    # download chunk file
    base_url = playlist.gsub('playlist.m3u8', '')
    chunk_url = base_url + chunk_file
    chunk_list = fetch(chunk_url)

    # create file list
    ts_files  = chunk_list
                .split(/\n/)
                .select { |line| line.match(/\.ts$/) }

    # save file list for ffpmeg
    File.open(TMP_FOLDER + 'list.txt', 'w') { |file| file.write(ts_files.map {|ts| ts = "file '#{ts}'"}.join("\n")) }

    # download ts files
    puts "Downloading #{ts_files.length} chunk files..."
    ts_files.each do |ts_file|
      ts_url = base_url + ts_file
      puts "Downloading: #{ts_url}" if options[:verbose] == true
      download(ts_url)
    end

    # transcode using ffpmeg
    video_file = get_filename(url).split('.')[0] + '.mp4'
    system "ffmpeg -f concat -i " + (TMP_FOLDER + 'list.txt') + " -c copy " + (TMP_FOLDER + 'all.ts') + " -loglevel 0"
    system "ffmpeg -i " + (TMP_FOLDER + 'all.ts') + " -acodec copy -vcodec copy #{video_file} -loglevel 0 -y"

    # remove temporary files
    Dir.glob(TMP_FOLDER + '*.ts').each { |file| File.delete(file) }
    Dir.glob(TMP_FOLDER + 'list.txt').each { |file| File.delete(file) }

    puts "File saved to: #{video_file}"
    puts 'Done.'
  else
    puts 'No playlist found.'
  end
end
