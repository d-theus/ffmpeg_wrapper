require 'spec_helper.rb'
require 'ffmpeg_wrapper/tools'

include FfmpegWrapper
include FfmpegWrapper::Tools

describe Compiler do
  subject(:com) { Compiler.new }
  subject(:vid) { MediaFile.new 'spec/media/video.avi' }
  subject(:aud) { MediaFile.new 'spec/media/audio.mp3' }
  it '#has accessible arrays of media' do
    expect(com).to respond_to(:audios)
    expect(com.audios).to be_kind_of Array
    expect(com).to respond_to(:videos)
    expect(com.videos).to be_kind_of Array
  end

  describe 'Streams' do
    describe '#<<' do
      subject(:vstr) { vid.streams.select(&:video?).first }
      subject(:astr) { vid.streams.select(&:audio?).first }
      it 'responds' do
        expect(com).to respond_to(:<<)
      end
      it 'makes sure argument is Stream' do
        expect { com << Stream.new(codec_type: 'video') }.not_to raise_error
        expect { com << OpenStruct.new }.to raise_error ArgumentError
      end
      it 'appends video to @videos and audio to @audios' do
        expect do
          com << vstr
        end.to change { com.videos }.from([]).to([vstr])
        expect do
          com << astr
        end.to change { com.audios }.from([]).to([astr])
      end
    end
  end
end
