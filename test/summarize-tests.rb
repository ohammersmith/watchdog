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
  include Watchdog

  sample_output = "  Duration: 0.012257 seconds.\n\
  Command: ls\n\
  Output:\n\
    InstalledFiles\n\
    README.txt\n\
    Rakefile\n\
    TODO.txt\n\
    bin\n\
    lib\n\
    setup.rb\n\
    share\n\
    test\n"
    
  def setup
  end

  def teardown
  end

  def test_summarize
    summary = summarize(sample_output)
  end
end
