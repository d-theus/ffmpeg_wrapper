require 'spec_helper.rb'

include FfmpegWrapper

describe FFmpeg do
  before(:each) { @ff = FFmpeg.new }
  subject { @ff }
  describe 'input functions: ' do
    let(:ins) { @ff.instance_variable_get(:@inputs) }
    let(:vids) { @ff.instance_variable_get(:@videos) }
    let(:auds) { @ff.instance_variable_get(:@audios) }
    it { should respond_to :media }
    it { should respond_to :video }
    it { should respond_to :audio }
    it '#media should modify @inputs, @videos and @audios'  do
      expect { @ff.media 'ololo' }
      .to change { ins.count }.from(0).to(1)
      expect { @ff.media 'ololo' }
      .to change { vids.count }.from(1).to(2)
      expect { @ff.media 'ololo' }
      .to change { auds.count }.from(2).to(3)
    end
    it '#video should modify @inputs and @videos only'  do
      expect { @ff.video 'ololo' }
      .to change { vids.count }.from(0).to(1)
      expect { @ff.video 'ololo' }
      .not_to change { auds.count }
      expect { @ff.video 'ololo' }
      .to change { ins.count }.from(2).to(3)
    end
    it '#audio should modify @inputs and @audios only'  do
      expect { @ff.audio 'ololo' }
      .to change { auds.count }.from(0).to(1)
      expect { @ff.audio 'ololo' }
      .not_to change { vids.count }
      expect { @ff.audio 'ololo' }
      .to change { ins.count }.from(2).to(3)
    end
  end
  describe '#run:' do
    after(:each) { `killall ffmpeg &>/dev/null` }
    it 'Module should respond to .run' do
      expect(FFmpeg).to respond_to :run
    end
    it 'should make valid commands given valid input' do
      expect do
        FFmpeg.run do
          v1 = media 'spec/media/video.avi'
          a1 = media 'spec/media/audio.mp3'
          map(v1, 0)
          map(a1, 0).applying acodec: 'libmp3lame'
          output 'spec/output/tmp.mp4'
        end
      end.not_to raise_error
    end
    it 'should provide access to external vars' do
      file_name = 'spec/media/video.avi'
      expect do
        FFmpeg.run do
          media file_name
        end.not_to raise_error
      end
    end
  end
end
