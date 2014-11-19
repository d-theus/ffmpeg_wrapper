module FfmpegWrapper
  class FFmpeg
    class << self
      def filter_concat(_mappings = {})
        line = ''
        line << filter_complex(:audio)
        line << filter_complex(:video)
        @filters << line
      end

      private

      def stream_map_for_video
        return if @videos.empty?
        line = ''
        @videos.size.times do |file|
          line << " [#{file}:0] "
        end
        line
      end

      def stream_map_for_audio
        return if @audios.empty?
        line = ''
        @audios.size.times do |file|
          line << " [#{file}:0] "
        end
        line
      end

      def concat_for_video
        "concat=n=#{@videos.size}:v=1:a=0 [v]"
      end

      def concat_for_audio
        "concat=n=#{@audios.size}:v=0:a=1 [a]"
      end

      def filter_complex(str)
        fail ArgumentError unless [:audio, :video].include?(str)
        str = str.to_s
        return '' if instance_variable_get('@' + str + 's').count < 2
        line = ' -filter_complex '
        line << "'"
        line << send("stream_map_for_#{str}")
        line << send("concat_for_#{str}")
        line << "'"
      end
    end
  end
end
