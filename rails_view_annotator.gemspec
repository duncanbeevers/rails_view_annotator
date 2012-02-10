# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails_view_annotator/version"

Gem::Specification.new do |s|
  s.name        = "rails_view_annotator"
  s.version     = RailsViewAnnotator::VERSION
  s.authors     = ["Duncan Beevers"]
  s.email       = ["duncan@dweebd.com"]
  s.homepage    = "https://github.com/duncanbeevers/rails_view_annotator"
  s.summary     = "Annotate Rails partial output with source path information"
  s.description = "The Rails View Annotator makes it easy to find out which partial generated which output"

  s.rubyforge_project = "rails_view_annotator"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end

