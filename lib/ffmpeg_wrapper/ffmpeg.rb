module FfmpegWrapper
  class FFmpeg
    class << self
      def run(&_block)
        setup
        @command = 'ffmpeg -y'
        yield(self)
        @command << ' ' << @inputs.join(' ')
        @command << ' ' << @filters.join(' ') if @filters.any?
        @command << ' ' << @mappings.join(' ') if @mappings.any?
        @command << ' ' << @output
        @command << ' 2>/dev/null'
        puts @command
        fail `#{@command} -v error 2>&1` unless system @command
      end

      def media(filename, opts = {})
        n = input(filename, opts)
        @videos << n
        @audios << n
        n
      end

      def video(filename, opts = {})
        n = input(filename, opts)
        @videos << n
        n
      end

      def audio(filename, opts = {})
        n = input(filename, opts)
        @audios << n
        n
      end

      def output(filename)
        @output = " #{filename}"
      end

      def map(file, index = nil)
        line =  "-map #{file}#{':' + index.to_s if index}"
        @mappings << line
        Mapping.new line
      end

      private

      def setup
        @inputs = []
        @audios = []
        @videos = []
        @mappings = []
        @filters = []
        @n = 0
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
