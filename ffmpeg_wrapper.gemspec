# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ffmpeg_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "ffmpeg_wrapper"
  spec.version       = FfmpegWrapper::VERSION
  spec.authors       = ['slowness']
  spec.email         = ['slma0x02@gmail.com']
  spec.summary       = 'Wrapper for FFmpeg.'
  spec.description   = 'FFmpeg is a powerful video, audio or image editing tool \
  with tons of useful (and not so) functions.'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
end
