require 'spec_helper.rb'

include FfmpegWrapper

describe FFmpeg do
  before(:all) { @ff = FFmpeg }
  subject { @ff }
  describe 'input functions: ' do
    before(:each) do
      FFmpeg.send(:setup)
    end
    let(:ins) { FFmpeg.instance_variable_get(:@inputs) }
    let(:vids) { FFmpeg.instance_variable_get(:@videos) }
    let(:auds) { FFmpeg.instance_variable_get(:@audios) }
    it { should respond_to :media }
    it { should respond_to :video }
    it { should respond_to :audio }
    it '#media should modify @inputs, @videos and @audios'  do
      expect { FFmpeg.media 'ololo' }
      .to change { ins.count }.from(0).to(1)
      expect { FFmpeg.media 'ololo' }
      .to change { vids.count }.from(1).to(2)
      expect { FFmpeg.media 'ololo' }
      .to change { auds.count }.from(2).to(3)
    end
    it '#video should modify @inputs and @videos only'  do
      expect { FFmpeg.video 'ololo' }
      .to change { vids.count }.from(0).to(1)
      expect { FFmpeg.video 'ololo' }
      .not_to change { auds.count }
      expect { FFmpeg.video 'ololo' }
      .to change { ins.count }.from(2).to(3)
    end
    it '#audio should modify @inputs and @audios only'  do
      expect { FFmpeg.audio 'ololo' }
      .to change { auds.count }.from(0).to(1)
      expect { FFmpeg.audio 'ololo' }
      .not_to change { vids.count }
      expect { FFmpeg.audio 'ololo' }
      .to change { ins.count }.from(2).to(3)
    end
  end
  describe '#run:' do
    after(:each) { `killall ffmpeg &>/dev/null` }
    it { should respond_to :run }
    it 'should make valid commands given valid input' do
      expect do
        FFmpeg.run do |ff|
          v1 = ff.media 'spec/media/video.avi'
          a1 = ff.media 'spec/media/audio.mp3'
          ff.map(v1, 0)
          ff.map(a1, 0).applying acodec: 'libmp3lame'
          ff.output 'spec/output/tmp.mp4'
        end
      end.not_to raise_error
    end
  end
end
