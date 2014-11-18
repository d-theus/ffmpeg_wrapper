module FfmpegWrapper
  class FFmpeg
    class << self
      def run(&_block)
        @command = 'ffmpeg -y'
        @n = 0
        yield(self)
        @command << ' 2>/dev/null'
        fail `#{@command} -v error 2>&1` unless system @command
      end

      def input(filename, opts = {})
        opts.each do |k, v|
          @command << " -#{k} #{v}"
        end
        @command << " -i #{filename}"
        @n += 1
        @n - 1
      end

      def output(filename)
        @command << ' ' << filename
      end

      def map(file, index = nil)
        @command << " -map #{file}#{':' + index.to_s if index}"
        Mapping.new @command
      end
    end
  end

  class Mapping < String
    def initialize(str)
      @cmdline = str
    end

    def applying(opts = {})
      opts.each do |k, v|
        @cmdline << " -#{k} #{v}"
      end
    end
  end
end
