# Panda Core

Core functionality shared between Panda Software gems:

- Panda CMS (https://github.com/pandacms/panda_cms)

## Installation

Add this line to your application's Gemfile:

    gem 'panda_core'

And then execute:

    $ bundle install

## Usage

### Shared Configuration Templates

PandaCore provides standard configuration files that can be used across all Panda gems to ensure consistency.

#### Using the Generator

PandaCore provides standard configuration files that can be used across all Panda gems to ensure consistency.

To install the configuration files:

    rails generate panda_core:templates

This will copy the following configuration files to your project:

- `.github/workflows/ci.yml` - GitHub Actions CI workflow
- `.github/dependabot.yml` - Dependabot configuration
- `.erb_lint.yml` - ERB linting rules
- `.eslintrc.js` - ESLint configuration
- `.gitattributes` - Git file handling rules
- `.gitignore` - Standard git ignore rules
- `.lefthook.yml` - Git hooks configuration
- `.rspec` - RSpec configuration
- `.standard.yml` - Ruby Standard configuration

#### Option 2: Using the Rake Task

    bundle exec rake panda_core:templates:install

#### Customizing Configurations

Some configuration files support inheritance. For example, to extend the standard Ruby style rules:

    # Your gem's .standard.yml
    inherit_gem:
      panda_core: lib/panda_core/templates/.standard.yml

    # Add your gem-specific overrides here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pandacms/panda_core.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
