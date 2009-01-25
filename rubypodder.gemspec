Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "rubypodder"
  s.version = "1.0.1"
  s.date = "2009-01-24"
  s.author = "Lex Miller"
  s.email = "lex.miller @nospam@ gmail.com"
  s.summary = "A podcast aggregator without an interface"
  s.files = Dir['lib/*.rb', 'tests/*', 'Rakefile'].to_a
  s.require_path = "lib"
  s.bindir = "bin"
  s.executables = ["rubypodder"]
  s.default_executable = "rubypodder"
  s.autorequire = "rubypodder"
  s.add_dependency("rio")
  s.add_dependency("rake")
  s.add_dependency("mocha")
  s.test_files = ["tests/tc_rubypodder.rb", "tests/tc_stdout.rb", "tests/ts_rubypodder.rb"]
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "MIT-LICENSE"]
end
