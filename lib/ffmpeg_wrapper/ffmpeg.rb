module FfmpegWrapper
  class FFmpeg
    class << self
      def run(&_block)
        @command = 'ffmpeg -y'
        @inputs = []
        @mappings = []
        @n = 0
        yield(self)
        @command << ' ' << @inputs.join(' ')
        @command << ' ' << @mappings.join(' ')
        @command << ' ' << @output
        @command << ' 2>/dev/null'
        puts @command
        fail `#{@command} -v error 2>&1` unless system @command
      end

      def input(filename, opts = {})
        line = ''
        opts.each do |k, v|
          line << " -#{k} #{v}"
        end
        line << "-i #{filename}"
        @inputs << line
        @n += 1
        @n - 1
      end

      def output(filename)
        @output = " #{filename}"
      end

      def map(file, index = nil)
        line =  "-map #{file}#{':' + index.to_s if index}"
        @mappings << line
        Mapping.new line
      end
    end
  end

  class Mapping
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
