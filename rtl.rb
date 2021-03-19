require 'open-uri'

class RTL

  HTML_TAG = /<rtl-player(?:[^>]+hls=\"(.*?)\"[^>]*)?>/
  HLS_MANIFEST = /(?:#EXT-X-STREAM-INF:)(?:BANDWIDTH=(?<BANDWIDTH>\d+),?|RESOLUTION=(?<RESOLUTION>\d+x\d+),?)*\n(?<FILE>[.\w]*)/m
  TMP_FOLDER = 'tmp/'

  def self.fetch(url)
    URI.parse(url).read
  end

  def self.filename(url)
    File.basename(URI.parse(url).path)
  end

  def self.download(url)
    data = fetch(url)
    open(File.join(TMP_FOLDER, filename(url)), 'wb+') do |file|
      file.write(data)
    end
  end

  def self.parse(url, options)
    if !ffmpeg?
      abort 'ffmpeg is not installed on this system'
    end

    quality = options[:quality].to_s
    puts "Selected video quality: #{quality}"
    puts "Parsing: #{url}"
    html = fetch(url)

    if html =~ HTML_TAG

      # extract playlist.m3u8 url from <rtl-player> tag
      playlist = html.scan(HTML_TAG)[0][0]
      puts "Found playlist: #{playlist}"

      # download playlist.m3u8
      hls = fetch(playlist)
      videos = hls.scan(HLS_MANIFEST)
      count = videos.size

      # adjust to next best available quality (fallback)
      unless hls.include? quality
        next_best_available_quality = videos.reverse.first[1]
        puts "WARNING -- Selected quality #{quality} not available, adjusting to next best quality #{next_best_available_quality}."
        quality = next_best_available_quality
      end

      # select chunk file for selected quality
      videos.select! { |video| video[1].include? quality }
      chunk_file = videos[0][2]
      if options[:verbose] == true
        puts "Found chunk list: #{chunk_file} (#{quality}) - out of #{count} chunk list" + (count > 1 ? 's' : '')
      end

      # download chunk file
      base_url = playlist.gsub('playlist.m3u8', '')
      chunk_url = base_url + chunk_file
      chunk_list = fetch(chunk_url)

      # create file list
      ts_files  = chunk_list.split(/\n/).select { |line| line.match(/\.ts$/) }

      # save file list for ffpmeg
      File.open(File.join(TMP_FOLDER, 'list.txt'), 'w') { |file|
        file.write(ts_files.map {|ts| ts = "file '#{ts}'"}.join("\n"))
      }

      # download ts files
      puts "Downloading #{ts_files.length} chunk files..."
      ts_files.each do |ts_file|
        ts_url = base_url + ts_file
        puts "Downloading: #{ts_url}" if options[:verbose] == true
        download(ts_url)
      end

      # transcode using ffpmeg
      video_file = filename(url).split('.')[0] + '.mp4'
      target_file = File.join(options[:target], video_file)
      list_file = File.join(TMP_FOLDER, 'list.txt')
      all_file = File.join(TMP_FOLDER, 'all.ts')
      system "ffmpeg -f concat -i #{list_file} -c copy #{all_file} -loglevel 0"
      system "ffmpeg -i #{all_file} -acodec copy -vcodec copy #{target_file} -loglevel 0 -y"

      # remove temporary files
      Dir.glob(File.join(TMP_FOLDER, '*.ts')).each { |file| File.delete(file) }
      File.delete(list_file)

      puts "File saved to: #{video_file}"
      puts 'Done.'
      video_file
    else
      puts 'No playlist found.'
      false
    end
  end

  def self.ffmpeg?
    system "which ffmpeg > /dev/null 2>&1"
  end

  def self.ffmpeg_version
    if ffmpeg?
      ffmpeg = %x[ffmpeg -version]
      ffmpeg.split("\n").first.match(/(?<=version n)(.*)(?= Copyright)/).to_s
    else
      false
    end
  end

end
