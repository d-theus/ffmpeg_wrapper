module FfmpegWrapper
  class FFmpeg
    def initialize
      @command = 'ffmpeg -y -hide_banner'
      @inputs = []
      @audios = []
      @videos = []
      @mappings = []
      @filters = []
      @n = 0
      @result = {}
      @post_exec_hooks = []
    end
    # Construct ffmpeg command using that
    # function, then execute. All opts hashe's
    # option meant to be axactly the same as according
    # ffmpeg flags. That is <tt>-pix_fmt => :pix_fmt</tt>
    # @return [FFmpeg]
    # @example
    #         FFmpeg.run do
    #           media 'somefile.mp4'
    #           map(0,1).applying acodec: 'libmp3lame',
    #                                ac: 2, ar: '44.1k'
    #           # .applying is a dynamic method of a
    #           # String returned from #map
    #           output 'out.mp3'
    #         end
    def self.run(&block)
      ff = FFmpeg.new
      ff.instance_eval do
        instance_eval(&block)
        @command << ' ' << @inputs.join(' ')
        @command << ' ' << @filters.join(' ') if @filters.any?
        @command << ' ' << @mappings.join(' ') if @mappings.any?
        @command << ' ' << @output if @output
        @out = IO.popen(@command, err: [:child, :out]) do |io|
          io.read
        end
        @post_exec_hooks.each { |h| instance_eval(&h) }
        fail @out.to_s unless $?.success?
      end
      ff.instance_variable_get(:@result)
    end

    # Adds input file, containing audio and video.
    # @param filename [String]
    # @param opts [Hash] options for this input file. See list
    # of options below.  If input file is a media container,
    # e. g. mpeg4 or avi you don't need to explicitly specify any.
    # If file is raw video or audio, specify _V_ for video
    # and _A_ for audio
    # @option opts [String] :f _V_ format 'rawvideo'
    # @option opts [String] :s _V_ geometry WxH(+X,Y)
    # @option opts [String] :pix_fmt _V_ pixel format bgr8, rgba, etc...
    # @option opts [Int]    :r _V_ fps
    # @option opts [String] :f _A_ format 'alaw', etc...
    # @option opts [String] :ar _A_ sample rate, e.g. '44.1k'
    # @option opts [Int] :ac _A_ channels
    # @see FFmpeg.map .run method example for call sequence
    # @return id [Integer] input file id
    def media(filename, opts = {})
      n = input(filename, opts)
      @videos << n
      @audios << n
      n
    end

    # Adds input video file (no audio will be extracted anyway)
    # @param filename [String]
    # @param opts [Hash] options for this input file
    # @return id [Integer] input file id
    def video(filename, opts = {})
      n = input(filename, opts)
      @videos << n
      n
    end

    # Adds input audio file (no video will be extracted anyway)
    # @param filename [String]
    # @param opts [Hash] options for this input file
    # @return id [Integer] input file id
    def audio(filename, opts = {})
      n = input(filename, opts)
      @audios << n
      n
    end

    # Specify filename for output file
    # @param filename [String]
    def output(filename)
      @output = " #{filename}"
    end

    # Specify mapping: what input stream or alias (from format, e. g. \[a\])
    # @param file [String, Int] file number or alias
    # @param index [Int] stream specifier
    # @see FFmpeg#map #map method example for call sequence
    # @see https://trac.ffmpeg.org/wiki/How%20to%20use%20-map%20option ffmpeg
    #   map option guide
    # @return [String]
    def map(file, index = nil)
      line =  "-map #{file}#{':' + index.to_s if index}"
      @mappings << line
      def line.applying(opts = {})
        opts.each do |k, v|
          self << " -#{k} #{v}"
        end
      end
      line
    end

    private

    def input(filename, opts = {})
      line = ''
      opts.each do |k, v|
        line << " -#{k} #{v}"
      end
      line << " -i #{filename}"
      @inputs << line
      @n += 1
      @n - 1
    end

  end
end
