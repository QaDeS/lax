NAME = "lax"
GEM_VERSION = "0.0.1"

LaxSpec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = GEM_VERSION
  s.date = "2008-12-27"

  s.authors = ["Michael Klaus"]
  s.email = "Michael.Klaus@gmx.net"
  s.summary = "A preprocessor to relax Ruby's syntax."
  s.description = "Lax is a preprocessor to relax Ruby syntax."
  s.executables = ["lax"]
  s.files = ["Rakefile", "README.rdoc", "lib/lax.rb"]
  s.has_rdoc = true
  s.homepage = "http://github.com/QaDeS/lax"
  s.rdoc_options = ["--title", "Lax", "--main", "README.rdoc", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.test_files = ["test/test.rb"]
end

