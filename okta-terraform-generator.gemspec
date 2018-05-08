lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'okta-terraform-generator'

Gem::Specification.new do |spec|
  spec.name          = 'okta-terraform-generator'
  spec.version       = OktaTerraformGenerator::VERSION
  spec.authors       = ['Stephen Hoekstra']
  spec.email         = ['shoekstra@schubergphilis.com']

  spec.description   = 'This gem installs helper scripts to generate Terraform plans based on user or group data from Okta.'
  spec.summary       = 'Helpers to generate Terraform plans using data from Okta'
  spec.homepage      = 'https://github.com/schubergphilis/okta-terraform-generator'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'facets', '~> 3.1'
  spec.add_dependency 'mixlib-cli', '~> 1.7'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'oktakit', '~> 0.2.0'
end
