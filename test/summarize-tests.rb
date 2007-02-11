# This file should be copied into a test ending in 'tests.rb' so that
# the Rakefile knows it's a test.

require "set-standalone-test-paths.rb" unless $started_from_rakefile
require 'test/unit'
require 's4t-utils'
include S4tUtils

## Require either the particular file under test like this:
# require 'watchdog/my-file'
## or the entire package:
# require 'watchdog'

class TestName < Test::Unit::TestCase

    
  def setup
  end

  def teardown
  end

  def test_summarize
    sample_output = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n"
    summary = Watchdog.summarize(sample_output)
    expected_summary = "1\n2\n3\n4\n5\n...\n16\n17\n18\n19\n20"
    assert_equal(expected_summary, summary)
    
    sample_output = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n"
    summary = Watchdog.summarize(sample_output)
    #expected_summary = "1\n2\n3\n4\n5\n...\n16\n17\n18\n19\n20"
    assert_equal(sample_output, summary)
  end
  
end
