require 'spec_helper.rb'
require 'ffmpeg_wrapper/filters/concat'

include FfmpegWrapper

describe FFmpeg do
  after(:each) { `killall ffmpeg &>/dev/null` }
  let(:vid) { 'spec/media/video.avi' }
  let(:aud) { 'spec/media/audio.mp3' }
  subject { FFmpeg }

  it { should respond_to(:filter_concat).with(0).arguments }
  it { should respond_to(:filter_concat).with(1).argument }
  it 'should run properly' do
    expect do
      FFmpeg.run do |ff|
        ff.video vid
        ff.video vid
        a = ff.audio aud
        ff.filter_concat
        ff.map '[v]'
        puts a.inspect
        ff.map(a).applying strict: '-2'
        ff.output 'spec/output/out.mp4'
      end
    end.not_to raise_error
    expect(FFmpeg.instance_variable_get(:@command)).to include '-filter_complex'
  end
end
