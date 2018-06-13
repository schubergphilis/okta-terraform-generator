# okta-terraform-generator

[![Build Status](https://travis-ci.org/schubergphilis/okta-terraform-generator.svg?branch=master)](https://travis-ci.org/schubergphilis/okta-terraform-generator)
[![Gem](https://img.shields.io/gem/v/okta-terraform-generator.svg)](https://rubygems.org/gems/okta-terraform-generator)

A command line helper to generate [Terraform](https://www.terraform.io/) files based on data found in an [Okta](https://www.okta.com/) tenant.

## Installation

This gem installs a `okta-terraform-generator` bin, to install it:

```
gem install okta-terraform-generator
```

## Usage

The installed bin writes a file matching the name of the generator used in the current working directory (e.g. `github_membership.tf` when using the `github_membership` generator), so you'll want to be in the directory containing your Terraform plans when running `okta-terraform-generator`.

Running `okta-terraform-generator` will print available generators, running `okta-terraform-generator GENERATOR_NAME` will print generator specific usage.

## Current Generators

The following resource generators are available:
  * github_membership

### `github_membership`

```
Usage: okta-terraform-generator github_membership (options)

Options:
    -h, --github-token GITHUB_TOKEN  Specifies the GitHub API token (required)
    -a OKTA_GITHUB_ADMIN_GROUP,      Specifies the Okta group containing GitHub admin users (required)
        --okta-github-admin-group
    -e OKTA_ENDPOINT,                Specifies the Okta API endpoint (e.g. https://myorg.okta.com/api/v1) (required)
        --okta-endpoint
    -g OKTA_GITHUB_USER_GROUP,       Specifies the Okta group containing GitHub users (can be a comma separated list) (required)
        --okta-github-user-group
    -t, --okta-token OKTA_TOKEN      Specifies the Okta API token (required)
```

## Contributing

We welcome contributed improvements and bug fixes via the usual work flow:

1. Fork this repository
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new pull request

## License & Authors

* Author: Stephen Hoekstra (shoekstra@schubergphilis.com)

```
Copyright 2018 Stephen Hoekstra <shoekstra@schubergphilis.com>
Copyright 2018 Schuberg Philis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Code of Conduct

Everyone interacting in the this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/schubergphilis/okta-terraform-generator/blob/master/CODE_OF_CONDUCT.md).
