# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'core_pro/version'

Gem::Specification.new do |spec|
  spec.name          = 'core_pro'
  spec.version       = CorePro::VERSION
  spec.authors       = ['Stas SUȘCOV']
  spec.email         = ['stas@nerd.ro']

  spec.summary       = 'CorePro Ruby SDK'
  spec.description   = 'Ruby SDK for working with CorePro web services.'
  spec.homepage      = 'https://github.com/HeyBetter/core_pro'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir.glob('{lib,spec}/**/*', File::FNM_DOTMATCH)
  spec.files        += %w[LICENSE.txt README.md]
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'http-rest_client'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
