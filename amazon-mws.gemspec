# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = %q{amazon-mws}
  s.version = "0.1.1.2"

  s.authors     = ["David Michael", "A. Edward Wible", "Alex Stubbs"]
  s.email       = ["david.michael@sonymusic.com", "aewible@gmail.com", "alex@alex-s.co.uk"]
  s.homepage    = "http://github.com/CPlus/amazon-mws"
  s.summary     = %q{A Ruby Wrapper for the Amazon MWS API}
  s.description = %q{A Ruby Wrapper for the Amazon MWS API - with specific additions to handle store submissions for CollectPlus}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features,examples}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "ruby-hmac", "~> 0.4.0"
  s.add_dependency "roxml", "~> 3.3.1"
  s.add_dependency "xml-simple", "~> 1.1.1"
  s.add_dependency "builder", ">= 3.0.0"
end
