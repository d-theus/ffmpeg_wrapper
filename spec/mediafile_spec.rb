require 'spec_helper.rb'

include FfmpegWrapper

describe MediaFile do
  describe '#initialize' do
    it 'requires filename' do
      expect { MediaFile.new }.to raise_error ArgumentError
      expect { MediaFile.new 'spec/media/video.avi' }.not_to raise_error
    end
    it 'checks file exist' do
      expect { MediaFile.new 'spec/media/nonexistent' }
      .to raise_error Errno::ENOENT
      expect { MediaFile.new 'spec/media/audio.mp3' }
      .not_to  raise_error
    end
    it 'handles fancy filenames' do
      expect { MediaFile.new 'spec/media/6. devise.mp3' }
      .not_to raise_error
    end
    it 'raises on non-media files' do
      expect { MediaFile.new 'spec' }
      .to raise_error
      expect { MediaFile.new 'spec/spec_helper.rb' }
      .to raise_error
    end
  end

  describe '#format' do
    subject(:mf) { MediaFile.new 'spec/media/video.avi' }
    it "doesn't call shell when format is present" do
      mf.format
      expect(mf).not_to receive(:format!)
      mf.format
    end
    it 'returns format' do
      expect(mf.format).to be_kind_of Format
    end
  end

  describe '#streams' do
    subject(:mf) { MediaFile.new 'spec/media/video.avi' }
    it "doesn't call shell when streams are present" do
      mf.streams
      expect(mf).not_to receive(:streams!)
      mf.streams
    end
    it 'returns array of streams' do
      expect(mf.streams).to be_kind_of Array
      expect(mf.streams.first).to be_kind_of Stream
    end
  end

  describe '#format!' do
    subject(:mf) { MediaFile.new 'spec/media/video.avi' }
    it 'calls shell anyways' do
      mf.format!
      expect(mf).to receive(:format!)
      mf.format!
    end
  end

  describe '#streams!' do
    subject(:mf) { MediaFile.new 'spec/media/video.avi' }
    it 'calls shell anyways' do
      mf.streams!
      expect(mf).to receive(:streams!)
      mf.streams!
    end
  end
end
