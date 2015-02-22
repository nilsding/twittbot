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
  spec.description   = %q{Twittbot is an advanced Twitter bot.  See the README and documentation for more info.}
  spec.homepage      = 'https://github.com/nilsding/twittbot'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'erubis', '~> 2.7', '>= 2.7.0'
  spec.add_dependency 'oauth', '~> 0.4'
  spec.add_dependency 'twitter', '~> 5.14'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
