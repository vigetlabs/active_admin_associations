# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_admin_associations/version"

Gem::Specification.new do |s|
  s.name        = "aa_associations"
  s.version     = ActiveAdminAssociations::VERSION
  s.authors     = ["Brian Landau"]
  s.email       = ["brian.landau@viget.com"]
  s.homepage    = "http://github.com/vigetlabs/active_admin_associations"
  s.summary     = %q{This extends ActiveAdmin to allow for better editing of associations.}
  s.description = %q{This extends ActiveAdmin to allow for better editing of associations.}
  s.date = '2012-05-03'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.add_dependency 'activeadmin', '~> 0.4'
  s.add_dependency 'rails', '~> 3.1'

  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'bundler', '~> 1.0'
end
