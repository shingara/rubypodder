require 'test/unit'

class StringStream < String
  def write(message)
    self.<< message
  end
end

def wrap(&b)
  raise "Expected block!" unless block_given?
  s = StringStream.new
  old = $stdout.clone
  $stdout = s
  b.call
  $stdout = old
  s
end

def last_log
  log = '/tmp/.rubypodder/rp.log'
  File.exists?(log) ? File.mtime('/tmp/.rubypodder/rp.log') : Time.at(0)
end

def exits_without_doing_anything(&b)
  raise "Expected block!" unless block_given?
  before = last_log
  b.call
  after = last_log
  before == after
end

class TC_stdout < Test::Unit::TestCase
  def setup
    ENV['HOME'] = "/tmp"
    @bindir = File.join(File.dirname(__FILE__), "..", "bin")
  end

  def teardown
    system("rm -rf " + "/tmp/.rubypodder")
  end

  def test_version
    assert_equal "rubypodder v0.1.4\n", wrap { puts `ruby #{@bindir}/rubypodder --version` }
    assert exits_without_doing_anything { `ruby #{@bindir}/rubypodder --version` }, "--version doesn't exit immediately"
  end

  def test_help
    assert_match %r{See http://rubypodder.rubyforge.org/}, wrap { puts `ruby #{@bindir}/rubypodder --help` }
    assert exits_without_doing_anything { `ruby #{@bindir}/rubypodder --help` }, "--help doesn't exit immediately"
  end

end
