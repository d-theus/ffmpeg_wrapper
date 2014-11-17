module FfmpegWrapper
  class Stream < OpenStruct
    def video?
      codec_type == 'video' if codec_type
    end

    def audio?
      codec_type == 'audio' if codec_type
    end
  end
end
