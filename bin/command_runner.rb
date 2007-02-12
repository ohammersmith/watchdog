#!/usr/bin/env ruby
#
# snagged from http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/118672

# patch that fixes the bug he was dealing with, it may be that this is patched in Ruby, but I wanted the reference
# > You actually need to run the test script with a shell redirection. Like
# > in the example output I gave, I redirected output of the script to a
# > file, output.txt, and then cat'ed it:
# > 
# >     $ ruby command_runner_shell_test.rb > output.txt
# >     $ cat output.txt
# 
# My apologies for not reading your post more carefully. Yes, I get the same
# here - and Matz has posted a patch which fixes it in Ruby. (However I'm not
# sure that fix is necessarily good; the same problem would happen with other
# filehandles which are open, and there's no proposal that fork() should flush
# all those too).
# 
# However you can also just fix your command_runner.rb like this:
# 
# --- command_runner.rb.orig      Tue Nov  2 13:21:01 2004
# +++ command_runner.rb   Tue Nov  2 13:21:41 2004
# @@ -33,6 +33,8 @@
#          child_to_parent_read, child_to_parent_write             = IO.pipe
#          child_to_parent_error_read, child_to_parent_error_write = IO.pipe
#          
# +        $stdout.flush
# +        $stderr.flush        
#          @childPid = fork do
#              parent_to_child_write.close
#              child_to_parent_read.close
# 
# (The $stderr.flush maybe isn't needed, as I seem to remember that stderr
# is unbuffered normally, but it won't do any harm to have it there)
# 
# Regards,
# 
# Brian.

class CommandRunner
    attr :command
    attr :childPid

    def initialize(*command)
        @command       = command
        @childPid      = nil
        
        @readPipe      = nil
        @readErrorPipe = nil
        @writePipe     = nil
    end

    def closeWrite
        @writePipe.close
    end

    def kill
        Process.kill("KILL", @childPid)
    end

    def read
        return @readPipe.read
    end

    def readError
        return @readErrorPipe.read
    end

    def run
        parent_to_child_read, parent_to_child_write             = IO.pipe
        child_to_parent_read, child_to_parent_write             = IO.pipe
        child_to_parent_error_read, child_to_parent_error_write = IO.pipe
        
        @childPid = fork do
            parent_to_child_write.close
            child_to_parent_read.close
            child_to_parent_error_read.close
            
            $stdin.reopen(parent_to_child_read) or
                    raise "Unable to redirect STDIN"
            $stdout.reopen(child_to_parent_write) or
                    raise "Unable to redirect STDOUT"
            $stderr.reopen(child_to_parent_error_write) or
                    raise "Unable to redirect STDERR"

            exec(*@command)
        end

        child_to_parent_write.close
        child_to_parent_error_write.close
        parent_to_child_read.close

        @readPipe      = child_to_parent_read
        @readErrorPipe = child_to_parent_error_read
        @writePipe     = parent_to_child_write
    end

    #--------------------------------------------------------------------------
    # Description: Waits for command to exit
    # Returns    : The return code of the program when it exited
    #--------------------------------------------------------------------------
    def wait
        if not @childPid
            raise "Waiting for a process that has not started"
        end

        return_value = Process.waitpid2(@childPid)[1].exitstatus
        
        @childPid = nil

        return return_value
    end

    def write(string)
        @writePipe.write(string)
    end
end
