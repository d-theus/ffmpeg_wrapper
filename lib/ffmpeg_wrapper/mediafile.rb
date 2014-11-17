require 'json'
require 'shellwords'
require 'pathname'

module FfmpegWrapper
  # Representing filesystem media file entry.
  # It's used to get and store file metadata,
  # extract Streams objects.
  class MediaFile
    PROBECMD = 'ffprobe -v quiet -of json '
    # Arguments:
    # * filename: String (Mandatory)
    def initialize(filename, options = {})
      @filename = Pathname filename
      raise Errno::ENOENT unless @filename.exist?
      raise Errno::EFTYPE unless media?
    end

    # Get format object. Lazy.
    def format
      @format || format!
    end

    # Get format object. Calls ffmpeg anyways.
    def format!
      js = `#{PROBECMD} -show_format #{filename_s}`
      puts `ffprobe\ -v verbose #{filename_s}` if js.empty?
      hash = JSON.parse js
      fmt_hash = hash.fetch('format') { raise 'Could not find format info.' }
      @format = Format.new fmt_hash
    end

    # Get streams from file. Lazy.
    def streams
      @streams || streams!
    end

    # Get streams from file. Calls ffmpeg anyways.
    def streams!
      js = `#{PROBECMD} -show_streams #{filename_s}`
      puts `ffprobe\ -v verbose #{filename_s}` if js.empty?
      hash = JSON.parse js
      str_hash = hash.fetch('streams') { raise 'Could not find streams info.' }
      @streams = str_hash.map { |str| Stream.new str }
    end

    private

    def media?
      `ffprobe -v error 2>&1 1>/dev/null -i #{filename_s}`.lines.empty?
    end

    def filename_s
      @filename.expand_path.to_s.shellescape
    end

  end
end
