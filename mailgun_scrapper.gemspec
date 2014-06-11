# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailgun_scrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "mailgun_scrapper"
  spec.version       = MailgunScrapper::VERSION
  spec.authors       = ["alok yadav"]
  spec.email         = ["yadav.alok29@gmail.com"]
  spec.description   = ""
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('rest-client', '~> 1.6.8.rc1')
  spec.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.1'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
