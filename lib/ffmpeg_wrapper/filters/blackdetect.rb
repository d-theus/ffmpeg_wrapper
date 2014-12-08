require 'ostruct'

module FfmpegWrapper
  class FFmpeg
    def filter_blackdetect(opts = {})
      @filters << '-vf blackdetect'
      @output = ' -f null /dev/null '
      @redirection = [:child, :out]
      @result[:blacks] = []
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
