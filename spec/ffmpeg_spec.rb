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
    after(:all) { `killall ffmpeg &>/dev/null` }
    file_presence = ->() { File.exist?('spec/output/video.mp4') }

    it 'Module should respond to .run' do
      expect(FFmpeg).to respond_to :run
    end

    it 'produces output' do
      expect do
        FFmpeg.run do
          media 'spec/media/video.mp4', t: 3
          map(0).applying strict: '-2'
          output 'spec/output/video.mp4'
        end
      end.to change { file_presence[] }.from(false).to(true)
    end

    it 'runs post_exec_hooks' do
      $h1, $h2 = nil, nil
      h1 = proc { $h1 = true }
      h2 = proc { $h2 = true }
      FFmpeg.run do
        media 'spec/media/video.mp4', t: 3
        map(0).applying strict: '-2'
        @post_exec_hooks << h1
        @post_exec_hooks << h2
        output 'spec/output/video.mp4'
      end
      expect($h1).to be_truthy
      expect($h2).to be_truthy
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

    routine = proc do
      fn = 'spec/media/video.mp4'
      FFmpeg.run do
        media fn
        map(0).applying f: 'null'
        output '/dev/null'
      end
    end

    it 'should provide access to external vars' do
      expect do
        routine[]
      end.not_to raise_error
    end

    it 'returns hash' do
      expect(routine[]).to be_a Hash
    end
  end
end
