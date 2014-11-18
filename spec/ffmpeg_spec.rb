require 'spec_helper.rb'

include FfmpegWrapper

describe FFmpeg do
  before(:all) { @ff = FFmpeg }
  subject { @ff }
  describe '#initialize:'
  describe '#run:' do
    after(:each) { `killall ffmpeg &>/dev/null` }
    it { should respond_to :run }
    it 'should make valid commands given valid input' do
      expect do
        FFmpeg.run do |ff|
          v1 = ff.input 'spec/media/video.avi'
          a1 = ff.input 'spec/media/audio.mp3'
          ff.map(v1, 0)
          ff.map(a1, 0).applying acodec: 'libmp3lame'
          ff.output '~/tmp.mp4'
        end
      end.not_to raise_error
    end
  end
end
