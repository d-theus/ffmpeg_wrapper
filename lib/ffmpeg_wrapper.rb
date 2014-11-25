require 'ffmpeg_wrapper/version'

module FfmpegWrapper
  # Check if ffmpeg is present in the system
  def self.method_missing(meth, *_args, &_blk)
    case meth.to_s
    when /has_(?<cmd>.*)\?/ then system "which #{$1} &>/dev/null"
    end
  end

  fail 'No ffmpeg found in $PATH' unless has_ffmpeg?
end

require 'ostruct'

require 'ffmpeg_wrapper/hash.rb'
require 'ffmpeg_wrapper/ffmpeg.rb'
require 'ffmpeg_wrapper/ffprobe.rb'
require 'ffmpeg_wrapper/format.rb'
require 'ffmpeg_wrapper/stream.rb'
require 'ffmpeg_wrapper/version.rb'
