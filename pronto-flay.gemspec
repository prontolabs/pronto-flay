# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'pronto/flay/version'

Gem::Specification.new do |s|
  s.name        = 'pronto-flay'
  s.version     = Pronto::FlayVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Mindaugas Mozūras'
  s.email       = 'mindaugas.mozuras@gmail.com'
  s.homepage    = 'http://github.org/mmozuras/pronto-flay'
  s.summary     = 'Pronto runner for Flay, structural similarities analyzer'

  s.required_rubygems_version = '>= 1.3.6'
  s.license = 'MIT'

  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'pronto', '~> 0.2.0'
  s.add_dependency 'flay', '~> 2.4.0'
  s.add_development_dependency 'rake', '~> 10.1.0'
  s.add_development_dependency 'rspec', '~> 2.14.0'
end
