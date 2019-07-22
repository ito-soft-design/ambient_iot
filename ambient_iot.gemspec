
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ambient_iot/version"

Gem::Specification.new do |spec|
  spec.name          = "ambient_iot"
  spec.version       = AmbientIot::VERSION
  spec.authors       = ["Katsuyoshi Ito"]
  spec.email         = ["kito@itosoft.com"]

  spec.summary       = %q{AmbientIot is a ruby library which helps to upload IoT data to the Ambient service.}
  spec.description   = %q{AmbientIot is a ruby library which helps to upload IoT data to the Ambient service.}
  spec.homepage      = "https://github.com/ito-soft-design/ambient_iot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
