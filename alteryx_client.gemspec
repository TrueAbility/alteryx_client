lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "alteryx_client/version"

Gem::Specification.new do |spec|
  spec.name          = "alteryx_client"
  spec.version       = AlteryxClient::VERSION
  spec.authors       = ["Dmitry Shagin"]
  spec.email         = ["dmitry@trueability.com"]

  spec.summary       = %q{Internal Gem to access Alteryx CommunityAPI}

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_dependency "awesome_print"
  spec.add_dependency "rest-client"
end
