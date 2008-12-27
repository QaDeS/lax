require 'rubygems'
require 'rake'
load 'lax.gemspec'


# ----- Packaging -----

require 'rake/gempackagetask'

Rake::GemPackageTask.new(LaxSpec) do |pkg|
end

desc "Install Lax as a gem."
task :install => [:package] do
  sudo = RUBY_PLATFORM =~ /win32/ ? '' : 'sudo'
  sh %{#{sudo} gem install --no-ri pkg/#{NAME}-#{GEM_VERSION}}
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


