require 'spec_helper.rb'

include FfmpegWrapper

describe FFmpeg do
  before(:all) { @ff = FFmpeg.new }
  subject { @ff }
  describe '#initialize:'
  describe '#run:' do
    after(:each) { `killall ffmpeg &>/dev/null` }
    it { should respond_to :run }
  end
  describe 'attributes:' do
    it { should respond_to :inputs }
    its(:inputs) { should be_an Array }
    its(:outputs) { should be_a Hash }
  end
end
