require 'json'

module FfmpegWrapper
  class FFprobe
    class << self
      # Execute ffprobe command.
      # @param [String] filename
      # @return [Hash]
      # @example
      #        info = FFprobe.run('video.mp4') do
      #          show_streams
      #          show_format
      #        end
      #        info                         #=> { "format" => ..., "streams"=>... }
      #        info['format']['codec_type'] #=> 'video'
      def run(filename, &block)
        ff = FFprobe.new filename
        ff.instance_eval do
          @command << ' -v quiet -of json'
          instance_eval &block
          @command << @show_specifiers.reduce(' ') do |acc, v|
            acc << " -#{v}"
            acc
          end
          @command << ' ' << @options.to_shellflags
          @command << ' ' << @input
          out = `#{@command} 2>/dev/null`
          begin
            JSON.parse out
          rescue JSON::ParserError
            raise 'FFprobe error. Check your command'
          end
        end
      end
    end

    # @param [String] filename
    def initialize(filename)
      @input = filename || fail(ArgumentError 'No input specified')
      @command = 'ffprobe '
      @show_specifiers = []
      @options = {}
    end

    # Specify input file options
    # @param [Hash] options
    def options(hash)
      @options.merge! hash
    end
    alias_method :option, :options

    private

    def method_missing(meth, *args, &blk)
      case meth
      when /show_(\w+)/ then
        @show_specifiers << meth
      else
        super
      end
    end


  end
end
