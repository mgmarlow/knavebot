require_relative "lib/knavebot/version"

Gem::Specification.new do |spec|
  spec.name = "knavebot"
  spec.version = Knavebot::VERSION
  spec.authors = ["Graham Marlow"]
  spec.email = ["mgmarlow@hey.com"]

  spec.summary = "A discord bot for knave"
  spec.homepage = "https://mgmarlow.github.io/knavebot/"
  spec.license = "GPL-3.0-or-later"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mgmarlow/knavebot"
  spec.metadata["changelog_uri"] = "https://github.com/mgmarlow/knavebot/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "discordrb"
  spec.add_dependency "dotenv"

  spec.add_development_dependency "standard"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
