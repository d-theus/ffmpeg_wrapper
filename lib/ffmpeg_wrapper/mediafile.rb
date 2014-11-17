require 'json'
require 'shellwords'
require 'pp'

module FfmpegWrapper
  PROBECMD = 'ffprobe -v quiet -of json '
  class MediaFile
    def initialize(filename, options = {})
      @filename = File.absolute_path(filename).shellescape
    end

    def format
      @format || format!
    end

    def format!
      js = `#{PROBECMD} -show_format #{@filename}`
      puts `ffprobe\ -v verbose #{@filename}` if js.empty?
      hash = JSON.parse js
      fmt_hash = hash.fetch('format') { raise 'Could not find format info.' }
      @format = Format.new fmt_hash
    end

    def streams
      @streams || streams!
    end

    def streams!
      js = `#{PROBECMD} -show_streams #{@filename}`
      puts `ffprobe\ -v verbose #{@filename}` if js.empty?
      hash = JSON.parse js
      str_hash = hash.fetch('streams') { raise 'Could not find streams info.' }
      @streams = str_hash.map { |str| OpenStruct.new str }
    end

  end
end
