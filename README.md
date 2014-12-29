# FfmpegWrapper

Ruby gem wrapping cli utility FFmpeg.
Now it lacks lots of features, but
this will change in time as I need new
functions myself or just feel like 
enhancing it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ffmpeg_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ffmpeg_wrapper

## Usage

### FFmpeg

```ruby
require 'ffmpeg_wrapper'

FFmpeg.run do
  media 'somefile.mp4'
  map(0,1).applying acodec: 'libmp3lame',
  ac: 2, ar: '44.1k'
    # .applying is a dynamic method of a
    # String returned from #map
  output 'out.mp3'
end
```


### FFprobe

``ruby
info = FFprobe.run('video.mp4') do
  show_streams
  show_format
  end
info #=> { "format" => ..., "streams"=>... }
info['format']['codec_type'] #=> 'video'
``

Look in the documentation for details.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ffmpeg_wrapper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
