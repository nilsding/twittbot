# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twittbot/defaults'

Gem::Specification.new do |spec|
  spec.name          = 'twittbot'
  spec.version       = Twittbot::VERSION
  spec.authors       = ['nilsding']
  spec.email         = ['nilsding@nilsding.org']
  spec.summary       = %q{An advanced Twitter bot.}
  spec.description   = %q{Twittbot is an advanced Twitter bot.  See the README for more info.}
  spec.homepage      = 'https://github.com/nilsding/twittbot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'erubis', '~> 2.7', '>= 2.7.0'
  spec.add_dependency 'oauth', '~> 0.5'
  spec.add_dependency 'twitter', '~> 5.16'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'bundler', '>= 1.7'
  spec.add_development_dependency 'rake', '~> 11.3'
end
