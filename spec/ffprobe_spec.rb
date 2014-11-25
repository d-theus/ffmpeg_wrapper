require 'spec_helper.rb'
require 'json'

include FfmpegWrapper

describe FFprobe do
  FFprobe.class_eval { def stub; end }
  before(:each) { @ff = FFprobe.new }
  vid = 'spec/media/video.avi'
  subject { @ff }
  describe 'Input:' do
    it { should respond_to :input }
  end
  describe '#run' do
    subject { FFprobe }
    it { should respond_to :run }
    it 'proper call does not raise' do
      expect do
        FFprobe.run do
          input vid
          stub
        end
      end.not_to raise_error
    end
    it 'error with no input' do
      expect do
        FFprobe.run do
          stub
        end
      end.to raise_error 'No input specified'
    end
    it 'returns ruby object' do
      expect(FFprobe.run do
        input vid
        show_format
      end).to be_a Hash
    end
  end
  describe 'Info type specifiers: FFmpeg' do
    %w(data error format streams chapters frames).each do |type|
      it "should respond to #{type}" do
        expect do
          FFprobe.run do
            input vid
            send("show_#{type}")
          end
        end.not_to raise_error
      end
    end
  end
end
