require 'spec_helper.rb'

describe FfmpegWrapper do
  it 'should check if ffmpeg is present in the system' do
    if system 'which ffmpeg &>/dev/null'
      expect { load 'lib/ffmpeg_wrapper.rb' }.not_to raise_error
      def FfmpegWrapper.has_ffmpeg?
        false
      end
      expect { load 'lib/ffmpeg_wrapper.rb' }.to raise_error RuntimeError
    else
      expect { load 'lib/ffmpeg_wrapper.rb' }.to raise_error RuntimeError
    end
  end
end
