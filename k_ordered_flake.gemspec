# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'k_ordered_flake/version'

Gem::Specification.new do |spec|
  spec.name          = "k_ordered_flake"
  spec.version       = KOrderedFlake::VERSION
  spec.authors       = ["R.J. osborne"]
  spec.email         = ["rjo1970@gmail.com"]

  spec.summary       = %q{A K-Ordered snowflake implementation}
  spec.description   = %q{K-Ordered values are alphabetically sortable by human-observable time, and requires no server coordination}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "concurrent-ruby", "~> 1.0.1"
  spec.add_dependency "macaddr", '~> 1.7', '>= 1.7.1'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end