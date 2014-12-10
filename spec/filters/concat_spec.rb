require 'spec_helper.rb'
require 'ffmpeg_wrapper/filters/concat'

include FfmpegWrapper

describe FFmpeg do
  before(:each) { @ff = FFmpeg.new  }
  after(:each) { `killall ffmpeg &>/dev/null` }
  subject { @ff }

  it { should respond_to(:filter_concat).with(0).arguments }
  it { should respond_to(:filter_concat).with(1).argument }
  it 'should run properly' do
    expect do
      vid = 'spec/media/video.avi'
      aud = 'spec/media/audio.mp3'
      @ff_run = FFmpeg.run do
        video vid
        video vid
        a = audio aud
        filter_concat
        map '[v]'
        map(a).applying strict: '-2'
        output 'spec/output/out.mp4'
      end
    end.not_to raise_error
  end
  describe '#filter_concat' do
    it 'returns 2 values: video source and audio source mappings' do
      vid = 'spec/media/video.avi'
      aud = 'spec/media/audio.mp3'
      a,v = nil
      @ff_run = FFmpeg.run(:debug) do
        video vid
        video vid
        audio aud
        v, a = filter_concat
        map v
        map(a).applying strict: '-2'
        output 'spec/output/out.mp4'
      end
      expect(a).to eq 2
      expect(v).to eq '[v]'
    end
  end
end
