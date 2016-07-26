Gem::Specification.new do |s|
  s.name = "fluent-plugin-ceph"
  s.version = "0.1.0"
  s.licenses    = ['Apache-2.0']
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Avinash Jha"]
  s.date = "2016-07-26"
  s.email = "avinash.jha2493@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "AUTHORS",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "fluent-plugin-ceph.gemspec",
    "lib/fluent/plugin/in_ceph.rb",
    "test/helper.rb",
    "test/plugin/test_in_ceph.rb"
  ]
  s.homepage = "http://github.com/aavinashjha/fluent-plugin-ceph"
  s.rubygems_version = "2.4.5"
  s.summary = "Ceph Input plugin for Fluent event collector"
end

