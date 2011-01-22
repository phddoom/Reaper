# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reaper/version"

Gem::Specification.new do |s|
  s.name        = "reaper"
  s.version     = Reaper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mitchell Garvin"]
  s.email       = ["garvinml@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A gem/binary to download anime from ww.animecrazy.net}
  s.description = %q{A gem/binary to download anime from ww.animecrazy.net}

  s.rubyforge_project = "reaper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "mechanize"
  s.add_dependency "clamp"
end
