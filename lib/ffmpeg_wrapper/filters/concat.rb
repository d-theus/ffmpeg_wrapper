module FfmpegWrapper
  module Tools
    # Used to compile several media files.
    # Streams can also be multiplexed (v + a).
    # It's also possible to make gaps between 
    # tracks. See TODO: example.
    class Compiler
      def run(&_block)
        @audios = []
        @videos = []
        @command = 'ffmpeg -y'
        @n = 0
        yield(self)
        @command << ' 2>/dev/null'
        fail `#{@command} -v error 2>&1` unless system @command
      end

      def apply_filters
        @command.sub(':afilter:',
                     if @audios.any?
                       "-filter_complex '\
                       #{}
                       concat=\
                       n=#{na}:v=0:a=1 [a]'"
                     else
                       ''
                     end
                    )
        if @videos.any?
        end
      end

      def input_audio(filename, opts = {})
        @audios << input(filename, opts)
      end

      def input_video(filename, opts = {})
        @videos << input(filename, opts)
      end


      def output(filename)
        @command << \
          ' :afilter: ' << \
          ' :vfilter: ' << \
          ' ' << filename
      end
    end
  end
end
