require 'json'

module FfmpegWrapper
  class FFprobe
    class << self
      def run(&block)
        ff = FFprobe.new
        ff.instance_eval do
          @command << ' -v quiet -of json'
          instance_eval &block
          fail 'No input specified' if @inputs.empty?
          @command << @show_specifiers.reduce(' ') do |acc, v|
            acc << " -#{v}"
            acc
          end
          out = `#{@command} 2>/dev/null`
          begin
            JSON.parse out
          rescue JSON::ParserError
            raise 'FFprobe error. Check your command'
          end
        end
      end
    end

    def initialize
      @command = 'ffprobe '
      @show_specifiers = []
      @inputs = []
    end

    def input(filename, opts = {})
      line = ''
      opts.each do |k, v|
        line << " -#{k} #{v}"
      end
      line << " -i #{filename}"
      @inputs << line
    end

    def method_missing(meth, *args, &blk)
      case meth
      when /show_(\w+)/ then
        @show_specifiers << meth
      else
        super
      end
    end

    def loglevel(mode)
      fail ArgumentError 'Unknown verbosity mode' unless LOGLEVELS.include? mode
      @loglevel = mode
    end
  end
end
