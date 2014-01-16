# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'signals/version'

Gem::Specification.new do |spec|
  spec.name          = "signals"
  spec.version       = Signals::VERSION
  spec.authors       = ["Matthew Johnston"]
  spec.email         = ["warmwaffles@gmail.com"]
  spec.description   = %q{A lightweight publish / subscribe library}
  spec.summary       = %q{A lightweight publish / subscribe library}
  spec.homepage      = "https://github.com/warmwaffles/signals"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "2.14.0"
end
