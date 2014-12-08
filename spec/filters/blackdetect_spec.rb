require 'spec_helper.rb'

include FfmpegWrapper
require 'ffmpeg_wrapper/filters/blackdetect'

describe FFmpeg do
  before(:each) { @ff = FFmpeg.new }
  subject { @ff }

  it { should respond_to(:filter_blackdetect).with(0).arguments }
  it { should respond_to(:filter_blackdetect).with(1).arguments }
  it { should respond_to(:detect_black).with(0).arguments }
  it { should respond_to(:detect_black).with(1).arguments }

  describe '#filter_blackdetect' do
    before { $filters = nil }
    let(:ff) do
      FFmpeg.run do
        input 'spec/media/video.mp4'
        filter_blackdetect
        $filters = @filters
      end
    end

    it 'does not complain about absent output' do
      expect do
        ff
      end.not_to raise_error
    end

    it 'modifies filters' do
      ff
      expect($filters).to include '-vf blackdetect'
    end

    it 'returns chainable object' do
      expect(FFmpeg.new.detect_black).to respond_to(:and_write_to).with(1).argument
    end

    it 'in run makes its returned hash to have :blacks' do
      expect(ff).to have_key :blacks
      expect(ff[:blacks]).to be_an Array
    end

    describe ':blacks array item' do
      subject do
        FFmpeg.run do
          input 'spec/media/blacks.mp4'
          filter_blackdetect
        end[:blacks].first
      end

      it { is_expected.not_to be_nil }
      its([:start]) { is_expected.to be_within(0.2).of(2.9) }
      its([:end]) { is_expected.to be_within(0.2).of(5.8) }
      its([:duration]) { is_expected.to be_within(0.2).of(2.9) }
    end

    describe 'produces output file' do
      file = 'spec/output/blackdetect.txt'

      before(:all) do
        FFmpeg.run do
          input 'spec/media/blacks.mp4'
          detect_black.and_write_to file
        end
      end

      let(:content) { File.read(file) }

      it 'which is exist' do
        expect(File.exist?(file)).to be_truthy
      end

      it 'which has proper line count' do
        expect(content.lines.count).to eq 1
      end

      it 'which has proper format' do
        expect(content.lines.first).to match(/black_interval start: .+ end: .+ duration: .+/)
      end
    end

  end
end
