# rtl-download

The app parses [RTL Télé Lëtzebuerg](https://www.rtl.lu/) web pages, detects and downloads videos and transcodes them into an `.mp4` file using ffmpeg. The app also includes a web frontend powered by [Sinatra](http://sinatrarb.com).

## Usage

### Requirements

Make sure to have up-to-date versions of [Ruby](https://www.ruby-lang.org/en/) and [ffmpeg](https://ffmpeg.org/) installed on your system.

* Debian: `sudo apt-get install ffmpeg`
* RHEL & Co: `sudo dnf install ffmpeg`
* Arch Linux: `sudo pacman -S ffmpeg`

Before you start the app, you need to install the necessary gems using `bundle install`.

### Web frontend

The app comes with a web frontend powered by Ruby, Sinatra and Puma. You can start the app with the commands `foreman start`, `ruby app.rb` or use simply make use of the `Procfile` for cloud deployments.

<img src="https://github.com/schopenhauer/rtl-download/blob/main/public/screenshot.png" width="550">

### Command-line usage

Hit the command line to use the script.

By default, the video quality will be set to a resolution of `1280x720` (high quality).

```
Usage: ruby dl.rb <URL> [options]
    -1, --low                        Low quality (640x360)
    -2, --average                    Average quality (854x480)
    -3, --high                       High quality (1280x720)
    -4, --highest                    Highest quality (1920x1080)
    -v, --verbose                    Verbose mode
    -o, --output=FOLDER              Specify output folder (optional)
    -h, --help                       Show help message
```

### Example

The `dl.rb` script should produce something like this:

```
$ ruby dl.rb https://www.rtl.lu/news/national/a/1372563.html -v

Using ffmpeg version: 4.3.1
Selected video quality: 1280x720
Parsing: https://www.rtl.lu/news/national/a/1372563.html
Found playlist: https://vod-edge.rtl.lu/replay/amlst:3170491/playlist.m3u8
Found chunk list: chunklist_b4408200.m3u8 (1280x720) - out of 4 chunk lists
Downloading 14 chunk files...
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_0.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_1.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_2.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_3.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_4.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_5.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_6.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_7.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_8.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_9.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_10.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_11.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_12.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b4408200_13.ts
File saved to: 1372563.mp4
Done.
```

## Credits

* [Ruby](https://www.ruby-lang.org/en/), [Sinatra](http://sinatrarb.com/) and [Puma](http://puma.io/)
* [Milligram](https://milligram.io/) CSS framework
* [ffmpeg](https://ffmpeg.org/)

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

The app is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
