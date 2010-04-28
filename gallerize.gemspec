# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gallerize}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Chapman"]
  s.date = %q{2010-04-28}
  s.email = %q{nchapman@gmail.com}
  s.files = ["bin/gallerize", "themes/default/index.html.erb", "themes/default/resources/screen.css", "themes/default/show.html.erb"]
  s.require_paths = ["lib"]
  s.executables = ["gallerize"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Create an HTML photo gallery from a directory of images}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rmagick>, [">= 2.13.1"])
      s.add_runtime_dependency(%q<naturalsort>, [">= 1.1.0"])
      s.add_runtime_dependency(%q<trollop>, [">= 1.16.2"])
    else
      s.add_dependency(%q<rmagick>, [">= 2.13.1"])
      s.add_dependency(%q<naturalsort>, [">= 1.1.0"])
      s.add_dependency(%q<trollop>, [">= 1.16.2"])
    end
  else
    s.add_dependency(%q<rmagick>, [">= 2.13.1"])
    s.add_dependency(%q<naturalsort>, [">= 1.1.0"])
    s.add_dependency(%q<trollop>, [">= 1.16.2"])
  end
end
