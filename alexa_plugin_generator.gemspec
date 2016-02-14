# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alexa_plugin_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "alexa_plugin_generator"
  spec.version       = AlexaPluginGenerator::VERSION
  spec.authors       = ["kylegrantlucas"]
  spec.email         = ["kglucas93@gmail.com"]

  spec.summary       = %q{A command line tool for generating singing_assistant middleware templates.}
  spec.description   = %q{A command line tool for generating singing_assistant middleware templates.}
  spec.homepage      = "http://github.com/kylegrantlucas/alexa_plugin_generator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'httparty'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
