require 'ostruct'

module FfmpegWrapper
  class FFmpeg
    # Find intervals of blackness in a video file.
    # This info then can be found in a hash, returned
    # from FFmpeg.run by key :blacks.
    # TODO: add argument support
    # @param opts [Hash]
    # @return FFmpeg self. Chainable, see example.
    # @example
    #         FFmpeg.run do
    #           media 'video.mp4'
    #           detect_black.and_write_to 'black_intervals.txt'
    #         end # => { ... :blacks => [ { :start => x, :end => y, :duration => z}, ... ] }
    def filter_blackdetect(opts = {})
      @filters << '-vf blackdetect'
      @output = ' -f null /dev/null '
      @redirection = [:child, :out]
      @result[:blacks] = []

      # Singleton method defined on FFmpeg
      # after calling #filter_blackdetect.
      # Writes info about black intervals as a plain text to
      # a file.
      # @param (String) filename
      def self.and_write_to(filename)
        @post_exec_hooks << proc do
          File.open(filename, 'w') do |f|
            @result[:blacks].each do |black|
              f.puts 'black_interval start: %f end: %f duration: %f' % [black[:start], black[:end], black[:duration]]
            end
          end
        end
      end
      @post_exec_hooks << proc do
        bdlines = @out.lines.grep(/blackdetect/)
        bdlines.map do |l|
          /black_start:(?<st>\S+).*
            black_end:(?<en>\S+).*
            black_duration:(?<du>\S+)/x =~ l
          @result[:blacks] << { start: st.to_f, end: en.to_f, duration: du.to_f }
        end
      end
      self
    end

    alias_method :detect_black, :filter_blackdetect
  end
end
