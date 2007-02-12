#! /sw/bin/ruby1.8
#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---

require 'pathname'
$:.unshift((Pathname.new(__FILE__).parent.parent + 'lib').to_s)
require 'watchdog/third-party/s4t-utils/load-path-auto-adjuster'

require 'extensions/string'
require 'open3'
require 's4t-utils'
include S4tUtils

require 'watchdog'
include Watchdog


class WatchdogCommand < Command

  def command_string(command_to_watch =
                       @user_choices[:command_to_watch])
    command_to_watch.join(' ')
  end

  def command_name(command_to_watch = @user_choices[:command_to_watch])
    progname = if command_to_watch[0] == 'ruby'
                 command_to_watch[1]
               else
                 command_to_watch[0]
               end
    File.basename(progname)
  end

  def message(duration, text)
    l = header(duration) + ["Output:", text.indent(2)]
    l.join("\n")
  end

  def header(duration)
    ["Duration: #{duration} seconds.", "Command: #{command_string}"]
  end
  
  def execute
    duration, text = Watchdog.time {
      #`#{self.command_string} 2>&1`
      IO.popen("#{self.command_string} 2>&1") { |output|
        buffer = ""
        while not output.eof
          line = output.gets
          @kennel.bark_line(line)
          buffer += line
        end
        buffer
      }      
    }
    title = "Program #{self.command_name} finished."
    msg = message(duration, text)
    @kennel.bark(title, msg, duration, header(duration).join("\n"))
  end

end    

if $0 == __FILE__
  without_pleasant_exceptions do
    WatchdogCommand.new.execute
  end
end

