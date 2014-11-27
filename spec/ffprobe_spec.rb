require 'spec_helper.rb'
require 'json'

include FfmpegWrapper

describe FFprobe do
  FFprobe.class_eval { def stub; end }
  vid = 'spec/media/video.avi'
  before(:each) { @ff = FFprobe.new vid }
  subject { @ff }
  describe '#run' do
    subject { FFprobe }
    it { should respond_to(:run) }
    it 'checks if block given' do
      expect do
        FFprobe.run(vid)
      end.not_to raise_error
    end
    it 'proper call does not raise' do
      expect do
        FFprobe.run(vid) do
          stub
        end
      end.not_to raise_error
    end
    it 'error with no input' do
      expect do
        FFprobe.run do
          stub
        end
      end.to raise_error ArgumentError
    end
    it 'returns ruby Hash' do
      expect(FFprobe.run(vid) do
        show_format
      end).to be_a Hash
    end

    let(:err) do
      FFprobe.run('spec/media/nonmedia.mp4') do
        show_format
      end
    end

    it 'returned Hash contains errors if any' do
      expect(err).to have_key 'errors'
      expect(err['errors']).to be_a String
      expect(err['errors']).not_to be_empty
    end
  end
  describe 'Info type specifiers: FFmpeg' do
    vid = 'spec/media/video.avi'
    describe '#show_format' do
      subject { FFprobe.run(vid) { show_format } }
      it { should be_a Hash }
      it { should have_key 'format' }
      its(['format']) { should be_a Hash }
      its(['format']) { should have_key 'duration' }
      its(['format']) { should have_key 'size' }
    end
    describe '#show_streams' do
      before(:each) { @res = FFprobe.run(vid) { show_streams } }
      subject { @res }
      it { should be_a Hash }
      it { should have_key 'streams' }
      it 'key streams provides access to proper array' do
        expect(@res['streams']).to be_an Array
        expect(@res['streams'].size).to eq 2
        expect(@res['streams'][0]).to have_key 'codec_type'
        expect(@res['streams'][0]['codec_type']).to eq 'video'
      end
    end
    describe '#show_chapters' do
      subject { FFprobe.run(vid) { show_chapters } }
      it { should be_a Hash }
      it { should have_key 'chapters' }
      its(['chapters']) { should be_an Array }
    end
    describe 'multiple quieries' do

      subject do
        FFprobe.run(vid) do
          show_chapters
          show_format
          show_streams
        end
      end

      it { should have_key 'streams' }
      it { should have_key 'format' }
      it { should have_key 'chapters' }
    end
  end
end
