require 'rubygems'
require 'rake'

# ----- Packaging -----

require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = %q{lax}
  s.version = "0.0.1"

  s.authors = ["Michael Klaus"]
  s.date = %q{2008-12-27}
  s.description = %q{Lax is a preprocessor to relax Ruby syntax.}
  s.email = %q{Michael.Klaus@gmx.net}
  s.executables = ["lax"]
  s.files = ["Rakefile", "README.rdoc", "lib/lax.rb", "test/test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://haml.hamptoncatlin.com/}
  s.rdoc_options = ["--title", "Lax", "--main", "README.rdoc", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{lax}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A preprocessor to relax Ruby's syntax.}
  s.test_files = ["test/test.rb"]

end
Rake::GemPackageTask.new(spec) do |pkg|
  if Rake.application.top_level_tasks.include?('release')
    pkg.need_tar_gz  = true
    pkg.need_tar_bz2 = true
    pkg.need_zip     = true
  end
end

desc "Install Lax as a gem."
task :install => [:package] do
  sudo = RUBY_PLATFORM =~ /win32/ ? '' : 'sudo'
  sh %{#{sudo} gem install --no-ri pkg/#{spec.name}-#{spec.version}}
end

# ----- Documentation -----

require 'rake/rdoctask'

Rake::RDocTask.new do |rdoc|
  rdoc.title    = 'Lax'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include(*FileList.new('*') do |list|
                            list.exclude(/(^|[^.a-z])[a-z]+/)
                            list.exclude('TODO')
                          end.to_a)
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.exclude('TODO')
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main = 'README.rdoc'
end

# ----- Coverage -----

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.test_files = FileList['test/test.rb']
    t.rcov_opts << '-x' << '"^\/"'
    if ENV['NON_NATIVE']
      t.rcov_opts << "--no-rcovrt"
    end
    t.verbose = true
  end
rescue LoadError; end


