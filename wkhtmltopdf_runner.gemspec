
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wkhtmltopdf_runner/version"

Gem::Specification.new do |spec|
  spec.name          = "wkhtmltopdf_runner"
  spec.version       = WkhtmltopdfRunner::VERSION
  spec.authors       = ["Justas Palumickas"]
  spec.email         = ["jpalumickas@gmail.com"]

  spec.summary       = 'Run wkhtmltopdf to generate HTML to PDF'
  spec.description   = 'Run wkhtmltopdf to generate HTML to PDF'
  spec.homepage      = 'https://github.com/jpalumickas/wkhtmltopdf_runner'
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/jpalumickas/wkhtmltopdf_runner'
  spec.metadata["changelog_uri"] = 'https://github.com/jpalumickas/wkhtmltopdf_runner/releases'
  spec.metadata["bug_tracker_uri"] = 'https://github.com/jpalumickas/wkhtmltopdf_runner/issues'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.requirements << 'wkhtmltopdf'
  spec.required_ruby_version = '>= 2.3.0'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
