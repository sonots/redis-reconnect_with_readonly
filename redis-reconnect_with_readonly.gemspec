# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis/reconnect_with_readonly/version'

Gem::Specification.new do |spec|
  spec.name          = "redis-reconnect_with_readonly"
  spec.version       = Redis::ReconnectWithReadonly::VERSION
  spec.authors       = ["Naotoshi Seo"]
  spec.email         = ["sonots@gmail.com"]

  spec.summary       = %q{Reconnect redis if Redis::CommandError READONLY occurs.}
  spec.description   = %q{Reconnect redis if Redis::CommandError READONLY occurs.}
  spec.homepage      = "https://github.com/sonots/redis-reconnect_with_readonly."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", ">= 3.3.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
