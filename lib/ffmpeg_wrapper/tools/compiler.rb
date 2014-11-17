module FfmpegWrapper
  module Tools
    # Used to compile several media files.
    # Streams can also be multiplexed (v + a).
    # It's also possible to make gaps between 
    # tracks. See TODO: example.
    class Compiler
      attr_accessor :audios, :videos
      def initialize
        @audios = []
        @videos = []
      end

      # Appends media stream to corresponding array, i. e.
      # video stream to @videos and audio stream to @audios.
      def <<(stream)
        raise ArgumentError unless stream.is_a? Stream
        raise 'Cannot determine codec_type for stream' unless stream.codec_type
          self.send("#{stream.codec_type}s") << stream
      end
    end
  end
end
