# frozen_string_literal: true

require_relative "lib/sidekiq_lifecycle_hooks/version"

Gem::Specification.new do |spec|
  spec.name = "sidekiq_lifecycle_hooks"
  spec.version = SidekiqLifecycleHooks::VERSION
  spec.authors = ["Will Taylor"]
  spec.email = ["wrftaylor@gmail.com"]

  spec.summary = "Asynchronous lifecycle hooks for rails apps using sidekiq."
  spec.homepage = "https://github.com/WillTaylor22/sidekiq_lifecycle_hooks."
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org'"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/WillTaylor22/sidekiq_lifecycle_hooks"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/WillTaylor22/sidekiq_lifecycle_hooks/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
