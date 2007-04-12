require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'
spec = Gem::Specification.new do |s|
    s.platform  =   Gem::Platform::RUBY
    s.name      =   "rubypodder"
    s.version   =   "0.1.2"
    s.author    =   "Lex Miller"
    s.email     =   "lex.miller @nospam@ gmail.com"
    s.summary   =   "A podcast aggregator without an interface"
    s.files     =   FileList['lib/*.rb', 'tests/*', 'Rakefile'].to_a
    s.require_path       = "lib"
    s.bindir             = "bin"
    s.executables        = ["rubypodder"]
    s.default_executable = "rubypodder"
    s.autorequire        = "rubypodder"
    s.add_dependency("rio")
    s.add_dependency("rake")
    s.test_files         = Dir.glob('tests/*.rb')
    s.has_rdoc           = true
    s.extra_rdoc_files   = ["README", "MIT-LICENSE"]
end
Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end
task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end
task :test do
    ruby "tests/ts_rubypodder.rb"
end
