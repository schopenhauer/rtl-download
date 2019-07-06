# rtl-transcoder

This Ruby script will parse [RTL Télé Lëtzebuerg](http://www.rtl.lu/) web pages, download their respective video files from the host server and transcode them into a valid `.mp4` video file locally using ffmpeg.

## Usage

### Requirements

You need to have [Ruby](https://www.ruby-lang.org/en/) and [ffmpeg](https://ffmpeg.org/) installed.

* `sudo apt-get install ffmpeg`
* `sudo pacman -S ffmpeg`

### Command-line usage

You hit the command line to use the script. By default, the video quality will be set to a resolution of `1280x720` (high quality).

```
Usage: ruby dl.rb <URL> [options]
    -1, --low                        Low quality (640x360)
    -2, --average                    Average quality (854x480)
    -3, --high                       High quality (1280x720)
    -4, --highest                    Highest quality (1920x1080)
    -v, --verbose                    Verbose mode
    -h, --help                       Show help message
```

### Example

The script should produce something like this:

```
$ ruby dl.rb https://www.rtl.lu/news/national/a/1372563.html

Using ffmpeg version: 4.1.3
Selected video quality: 1920x1080
Parsing: https://www.rtl.lu/news/national/a/1372563.html
Found playlist: https://vod-edge.rtl.lu/replay/amlst:3170491/playlist.m3u8
Found chunk list: chunklist_b6406090.m3u8 (1920x1080) - out of 4 chunk lists
Downloading 14 chunk files...
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_0.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_1.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_2.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_3.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_4.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_5.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_6.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_7.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_8.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_9.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_10.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_11.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_12.ts
Downloading: https://vod-edge.rtl.lu/replay/amlst:3170491/media_b6406090_13.ts
File saved to: 1372563.mp4
Done.
```

## Credits

* [Ruby](https://www.ruby-lang.org/en/)
* [ffmpeg](https://ffmpeg.org/)

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

The app is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).