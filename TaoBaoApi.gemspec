# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'TaoBaoApi/version'

Gem::Specification.new do |spec|
  spec.name          = "TaoBaoApi"
  spec.version       = TaoBaoApi::VERSION
  spec.authors       = ["wikimo"]
  spec.email         = ["gwikimo@gmail.com"]
  spec.description   = %q{ get goods info from taobao}
  spec.summary       = %q{ get goods info from taobao just with url}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "nokogiri", '1.5.10'
end
