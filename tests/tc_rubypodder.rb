$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'rubypodder'
require 'mocha'

class TC_RubyPodder < Test::Unit::TestCase

  def setup
    system("rm -rf " + "/tmp/test_rp.conf")
    system("rm -rf " + "/tmp/test_rp.done")
    File.open("/tmp/test_rp.conf", "w") do |file|
      file.write("# This is just a comment\n")
      file.write("http://downloads.bbc.co.uk/rmhttp/downloadtrial/radio4/thenowshow/rss.xml\n")
      file.write("# This is just another comment\n")
      file.write("http://www.guardian.co.uk/podcasts/comedy/rickygervais/mp3.xml\n")
    end
    @subdir = "/tmp/subdir"
    system("rm -rf " + @subdir)
    @rp = RubyPodder.new("/tmp/test_rp")
  end

  def teardown
    system("rm -rf " + "/tmp/test_rp.conf")
    system("rm -rf " + "/tmp/test_rp.done")
    system("rm -rf " + "/tmp/test_rp.log")
    system("rm -rf " + "/tmp/#{@rp.date_string(Time.now)}")
    system("rm -rf " + @subdir)

  end

  def test_initialize_with_test_config_file
    assert_kind_of(RubyPodder, @rp)
    assert_equal("/tmp/test_rp.conf", @rp.conf_file)
    assert_equal("/tmp/test_rp.log", @rp.log_file)
    assert_equal("/tmp/test_rp.done", @rp.done_file)
  end

  def test_initialize_with_default_config_file
    ENV['HOME'] = "/tmp"
    @rp = RubyPodder.new()
    assert_kind_of(RubyPodder, @rp)
    assert_equal(ENV['HOME'] + "/.rubypodder/rp.conf", @rp.conf_file)
    assert_equal(ENV['HOME'] + "/.rubypodder/rp.log", @rp.log_file)
    assert_equal(ENV['HOME'] + "/.rubypodder/rp.done", @rp.done_file)
    system("rm -rf " + "/tmp/.rubypodder")
  end

  def test_initialize_with_absent_config_file
    file_base = "/tmp/test_rp"
    file_conf = file_base + ".conf"
    system("rm -rf " + file_conf)
    @rp = RubyPodder.new(file_base)
    assert(File.exists?(file_conf))
    system("rm -rf " + file_conf)
  end

  def test_make_dirname_one_subdir
    filename = @subdir + "/file"
    @rp.make_dirname(filename)
    assert(File.exists?(@subdir))
  end

  def test_make_dirname_many_subdir
    subsubdirs = "/subsubdir/subsubsubdir"
    filename = @subdir + subsubdirs + "/file"
    @rp.make_dirname(filename)
    assert(File.exists?(@subdir + subsubdirs))
  end

  def test_date_string
    t = Time.gm(2006,"dec",18,21,0,0)
    date_string = @rp.date_string(t)
    assert_equal(date_string, "2006-12-18")
  end

  def test_initialize_with_absent_config_file_dir
    file_base = @subdir + "/test_rp"
    file_conf = file_base + ".conf"
    @rp = RubyPodder.new(file_base)
    assert(File.exists?(file_conf))
  end

  def test_initialize_creates_date_dir
    file_base = @subdir + "/test_rp"
    @rp = RubyPodder.new(file_base)
    date_dir = @subdir + "/" + @rp.date_string(Time.now)
    assert_equal(date_dir, @rp.date_dir)
    assert(File.exists?(date_dir), "Subdirectory #{date_dir} not created")
  end

  def test_read_feeds
    feed_list = @rp.read_feeds
    assert_kind_of(Array, feed_list)
    assert_equal(2, feed_list.length)
    assert_equal("http://downloads.bbc.co.uk/rmhttp/downloadtrial/radio4/thenowshow/rss.xml", feed_list[0])
    assert_equal("http://www.guardian.co.uk/podcasts/comedy/rickygervais/mp3.xml", feed_list[1])
  end

  def test_parse_rss
    #rss_source = IO.read("test_feed.xml")
    rss_source = <<-END_OF_STRING
    <?xml version="1.0" encoding="utf-8"?>
    <rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
        <channel>
            <lastBuildDate>Fri, 27 Oct 2006 16:50:15 +0100</lastBuildDate>
            <title>The Ricky Gervais Show</title>
            <itunes:author>Guardian Unlimited</itunes:author>
            <link>http://www.guardian.co.uk/rickygervais</link>
            <generator>Podcast Maker v1.2.4 - http://www.potionfactory.com/podcastmaker</generator>
            <description>Ricky Gervais, Steve Merchant and Karl Pilkington are back yada yada</description>
            <itunes:subtitle />
            <itunes:summary>Ricky Gervais, Steve Merchant and Karl Pilkington are back yada yada</itunes:summary>
            <language>en</language>
            <copyright>Ricky Gervais, Steve Merchant, Karl Pilkington</copyright>
            <itunes:owner>
            <itunes:name>Glyn Hughes</itunes:name>
            <itunes:email>glyn@rickygervais.com</itunes:email>
            </itunes:owner>
            <image>
                <url>http://podcast.rickygervais.com/gu_p123_300_144.jpg</url>
                <title>The Ricky Gervais Show</title>
                <link>http://www.guardian.co.uk/rickygervais</link>
                <width>144</width>
                <height>144</height>
            </image>
            <itunes:image href="http://podcast.rickygervais.com/gu_p123_300.jpg" />
            <category>Comedy</category>
            <itunes:category text="Comedy" />
            <itunes:keywords>Ricky, Gervais, Steve, Merchant, Karl, Pilkington</itunes:keywords>
            <itunes:explicit>yes</itunes:explicit>
            <item>
                <title>The Podfather Part I - Halloween</title>
                <itunes:author>Guardian Unlimited</itunes:author>
                <description>The first of three specials from Ricky, Steve and Karl yada yada</description>
                <itunes:subtitle>The first of three specials from Ricky, Steve and Karl yada yada</itunes:subtitle>
                <itunes:summary />
                <enclosure type="audio/mpeg" url="http://podcast.rickygervais.com/guspecials_halloween.mp3" length="15723925" />
                <guid>http://podcast.rickygervais.com/guspecials_halloween.mp3</guid>
                <pubDate>Tue, 31 Oct 2006 00:00:01 +0000</pubDate>
                <category>Comedy</category>
                <itunes:explicit>yes</itunes:explicit>
                <itunes:duration>00:37:22</itunes:duration>
                <itunes:keywords>Ricky, Gervais, Steve, Merchant, Karl, Pilkington</itunes:keywords>
            </item>
        </channel>
    </rss>
    END_OF_STRING
    rss = @rp.parse_rss(rss_source)
    assert_equal(1, rss.items.length)
    assert_equal("http://podcast.rickygervais.com/guspecials_halloween.mp3", rss.items[0].enclosure.url)
  end

  def test_dest_file_name(url)
    correct_dest_file_name = @rp.date_dir + "/" + "podcast.mp3"
    dest_file_name = @rp.dest_file_name("http://www.podcast.com/podcast.mp3")
    assert_equal(correct_dest_file_name, dest_file_name)
    dest_file_name = @rp.dest_file_name("http://www.podcast.com/subdir/podcast.mp3")
    assert_equal(correct_dest_file_name, dest_file_name)
  end

  def test_download
    @rp.download("http://www.google.com/index.html")
    dest_file = @rp.date_dir + "/" + "index.html"
    assert(File.exists?(dest_file))
    assert(File.open(dest_file).grep(/google/))
  end

  def test_download_recorded
    @rp.download("http://www.google.com/index.html")
    assert(File.exists?(@rp.done_file))
    assert(File.open(@rp.done_file).grep(/^http:\/\/www.google.com\/index.html$/))
  end

  def test_already_downloaded
    url1 = "http://www.google.com/index.html"
    assert(!@rp.already_downloaded(url1), "url1 should not be already downloaded before download of url1")
    @rp.download(url1)
    assert(@rp.already_downloaded(url1), "url1 should be already downloaded after download of url1")
    url2 = "http://www.google.co.nz/index.html"
    @rp.download(url2)
    assert(@rp.already_downloaded(url2), "url2 should be already downloaded after download of url2")
    assert(@rp.already_downloaded(url1), "url1 should still be already downloaded after download of url2")
  end

  def test_download_omits_done_items
    @rp.download("http://www.google.com/index.html")
    dest_file = @rp.date_dir + "/" + "index.html"
    system("rm -rf " + dest_file)
    @rp.download("http://www.google.com/index.html")
    assert(!File.exists?(dest_file))
  end

  def test_download_error_is_logged
    @rp.download("http://very.very.broken.url/oh/no/oh/dear.xml")
    File.open( @rp.log_file ) do |f|
      assert(f.any? { |line| line =~ /ERROR/ }, "Error in download should be logged")
    end
  end

  def test_remove_dir_if_empty
    system("mkdir -p " + @subdir)
    @rp.remove_dir_if_empty(@subdir)
    assert(!File.exists?(@subdir))
    system("mkdir -p " + @subdir)
    system("touch " + @subdir + "/fish")
    @rp.remove_dir_if_empty(@subdir)
    assert(File.exists?(@subdir))
  end

  def test_log_contains_version
    File.open("/tmp/test_rp.conf", "w") { |file| file.write("# Empty config file\n") }
    @rp = RubyPodder.new("/tmp/test_rp")
    @rp.run
    File.open( @rp.log_file ) do |f|
      assert(f.any? { |line| line =~ /Starting.+#{RubyPodder::Version}/ }, "'Starting' log entry should contain '#{RubyPodder::Version}'")
    end
  end

  def test_log_contains_error_for_unreadable_feed_url
    File.open("/tmp/test_rp.conf", "w") { |file| file.write("http://very.very.broken.url/oh/no/oh/dear.xml\n") }
    @rp = RubyPodder.new("/tmp/test_rp")
    @rp.run
    File.open( @rp.log_file ) do |f|
      assert(f.any? { |line| line =~ /ERROR/ }, "Error in feed url should be logged")
    end
  end

  def test_log_contains_error_for_unparsable_rss_source
    @rp.stubs(:parse_rss).raises(RSS::NotWellFormedError, 'This is not well formed XML')
    @rp.run
    File.open( @rp.log_file ) do |f|
      assert(f.any? { |line| line =~ /ERROR/ }, "Parse error in rss source should be logged")
    end
  end

end
