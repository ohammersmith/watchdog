#! /sw/bin/ruby1.8

### The following adjusts the load path so that the correct version of
### a self-contained package is found, no matter where the script is
### run from. 
require 'pathname'
$:.unshift((Pathname.new(__FILE__).parent.parent + 'lib').to_s)
require 'watchdog/third-party/s4t-utils/load-path-auto-adjuster'


require 's4t-utils'
include S4tUtils

require 'watchdog'

if $0 == __FILE__
   without_pleasant_exceptions do
     Thread.abort_on_exception = false
     thread = Thread.new {
       IO.popen("./sleeper.sh") { |output|
         while not output.eof
           puts output.gets
         end
         puts "#{Process.pid} is here, output is #{output}"
       }
     }
     puts "#{Process.pid} is here"
     thread.join
  end
end
