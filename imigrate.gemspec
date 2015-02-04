# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "imigrate/version"

Gem::Specification.new do |s|
  s.name        = "imigrate"
  s.version     = Imigrate::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthieu Paret"]
  s.email       = ["matthieu@ifeelgoods.com"]
  s.homepage    = "https://github.com/ifeelgoods/imigrate"
  s.summary     = %q{Rake tasks to migrate data for Rails application.}
  s.description = %q{Rake tasks to migrate data for Rails application.}
  s.license     = 'Apache License Version 2.0'

  s.add_development_dependency "rails", ">= 4.1.0"
  s.add_development_dependency "rspec-rails", ">= 3.1.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "database_cleaner"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
