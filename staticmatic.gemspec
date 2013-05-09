# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{staticmatic}
  load 'lib/staticmatic/version.rb'
  s.version = StaticMatic::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Bartholomew"]
  s.date = %q{2010-11-15}
  s.homepage = %q{http://staticmatic.net}
  s.description = %q{Lightweight Static Site Framework}
  s.email = %q{steve@curve21.com}

  s.rubyforge_project = %q{staticmatic}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Lightweight Static Site Framework}

  s.default_executable = %q{staticmatic}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<haml>, ["3.1.3"])
      s.add_runtime_dependency(%q<rack>, ["1.3.4"])
      s.add_runtime_dependency(%q<compass>, ["0.11.1"])
      s.add_runtime_dependency(%q<gettext>, ["2.3.9"])
      s.add_runtime_dependency(%q<rspec>, ["1.3.2"])
    else
      s.add_dependency(%q<haml>, ["3.1.3"])
      s.add_dependency(%q<rack>, ["1.3.4"])
      s.add_dependency(%q<compass>, ["0.11.1"])
      s.add_dependency(%q<gettext>, ["2.3.9"])
      s.add_dependency(%q<rspec>, ["1.3.2"])
    end
  else
    s.add_dependency(%q<haml>, ["3.1.3"])
    s.add_dependency(%q<rack>, ["1.3.4"])
    s.add_dependency(%q<compass>, ["0.11.1"])
    s.add_dependency(%q<gettext>, ["2.3.9"])
    s.add_dependency(%q<rspec>, ["1.3.2"])
  end
end
