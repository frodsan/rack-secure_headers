require_relative "lib/rack/secure_headers/version"

Gem::Specification.new do |s|
  s.name        = "rack-secure_headers"
  s.version     = Rack::SecureHeaders::VERSION
  s.summary     = "Security related HTTP headers for Rack applications"
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez"]
  s.email       = ["frodsan@protonmail.ch"]
  s.homepage    = "https://github.com/harmoni/rack-secure_headers"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "rack", "~> 1.6.4"
  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "cutest", "~> 1.2"
end
