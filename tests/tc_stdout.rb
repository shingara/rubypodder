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
  end

  def teardown
    system("rm -rf " + "/tmp/.rubypodder")
  end

  def test_version
    assert_equal "rubypodder v0.1.1\n", wrap { puts `ruby ../bin/rubypodder --version` }
    assert exits_without_doing_anything { `ruby ../bin/rubypodder --version` }, "Doesn't exit immediately"
  end
end
