#---
# Excerpted from "Everyday Scripting in Ruby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/bmsft for more book information.
#---
require "set-standalone-test-paths.rb" unless $started_from_rakefile
require 'test/unit'
require 's4t-utils'
include S4tUtils

require 'watchdog/choices'
include Watchdog

class ChoicesTests < Test::Unit::TestCase

  class Revealer < WatchdogCommand
    attr_reader :user_choices
  end

  Sample_XML = %Q{
      <watchdog>
        <command-line>true</command-line>
        <jabber>true</jabber>
        <mail>true</mail>
        <growl>true</growl>
        <growl-summary>false</growl-summary>
        <jabber-summary>false</jabber-summary>
        <mail-summary>true</mail-summary>
        
        <growl-threshold>5</growl-threshold>
        <mail-threshold>6</mail-threshold>
        <jabber-threshold>7</jabber-threshold>
      
        <mail-to>recipient@example.com</mail-to>
        <mail-from>bmarick@mac.com</mail-from>
        <mail-server>smtp.mac.com</mail-server>
        <mail-port>587</mail-port>
        <mail-from-domain>exampler.com</mail-from-domain>
        <mail-account>bmarick</mail-account>
        <mail-password>a password</mail-password>
        <mail-authentication>login</mail-authentication>
      
        <jabber-account>watchdog@mobile-marick.local/bark</jabber-account>
        <jabber-to>marick@mobile-marick.local/iChat</jabber-to>
        <jabber-password>password</jabber-password>
      </watchdog>
  }

  def test_xml_config_file
    with_command_args('command to run') {
      with_local_config_file('.watchdog.xml', Sample_XML) {
        dog = Revealer.new
        
        assert_equal(true, dog.user_choices[:command_line])
        assert_equal(true, dog.user_choices[:jabber])
        assert_equal(true, dog.user_choices[:mail])
        assert_equal(true, dog.user_choices[:growl])
        assert_equal(false, dog.user_choices[:growl_summary])
        assert_equal(false, dog.user_choices[:jabber_summary])
        assert_equal(true, dog.user_choices[:mail_summary])
        assert_equal(5, dog.user_choices[:growl_threshold])
        assert_equal(6, dog.user_choices[:mail_threshold])
        assert_equal(7, dog.user_choices[:jabber_threshold])
        assert_equal(['recipient@example.com'], dog.user_choices[:mail_to])
        assert_equal('bmarick@mac.com', dog.user_choices[:mail_from])
        assert_equal('smtp.mac.com', dog.user_choices[:mail_server])
        assert_equal(587, dog.user_choices[:mail_port])
        assert_equal('exampler.com', dog.user_choices[:mail_from_domain])
        assert_equal('bmarick', dog.user_choices[:mail_account])
        assert_equal('a password', dog.user_choices[:mail_password])
        assert_equal(:login, dog.user_choices[:mail_authentication])
        assert_equal('watchdog@mobile-marick.local/bark',
                     dog.user_choices[:jabber_account])
        assert_equal(['marick@mobile-marick.local/iChat'],
                     dog.user_choices[:jabber_to])
        assert_equal('password', dog.user_choices[:jabber_password])

        assert_equal(['command', 'to', 'run'],
                     dog.user_choices[:command_to_watch])
      }
    }
  end

  def test_command_line
    erasing_local_config_file('.watchdog-config.xml') do
      with_command_args(['--no-jabber --no-mail --no-terminal --growl ',
                          '--growl-summary --jabber-summary --mail-summary ',
                          '--growl-threshold 11 --jabber-threshold 12 --mail-threshold 13 ',
                          '--mail-to fred,betty ',
                          '--mail-from me',
                          '--mail-server hostname ',
                          '--mail-port 29 ',
                          '--mail-account fred',
                          '--mail-from-domain testing.com',
                          '--mail-password Mpassword',
                          '--mail-authentication cram_md5',
                          '--jabber-to marick@jabber.org/foo',
                          '--jabber-account woofer@jabber.org',
                          '--jabber-password Jpassword',
                          'this that and the other'].join(' ')) {
        dog = Revealer.new
        
        assert_equal(false, dog.user_choices[:command_line])
        assert_equal(false, dog.user_choices[:jabber])
        assert_equal(false, dog.user_choices[:mail])
        assert_equal(true, dog.user_choices[:growl])
        assert_equal(true, dog.user_choices[:growl_summary])
        assert_equal(true, dog.user_choices[:jabber_summary])
        assert_equal(true, dog.user_choices[:mail_summary])
        assert_equal(11, dog.user_choices[:growl_threshold])
        assert_equal(12, dog.user_choices[:jabber_threshold])
        assert_equal(13, dog.user_choices[:mail_threshold])
        assert_equal(['fred', 'betty'], dog.user_choices[:mail_to])
        assert_equal('me', dog.user_choices[:mail_from])
        assert_equal('hostname', dog.user_choices[:mail_server])
        assert_equal(29, dog.user_choices[:mail_port])
        assert_equal('testing.com', dog.user_choices[:mail_from_domain])
        assert_equal('fred', dog.user_choices[:mail_account])
        assert_equal('Mpassword', dog.user_choices[:mail_password])
        assert_equal(:cram_md5, dog.user_choices[:mail_authentication])
        assert_equal(['marick@jabber.org/foo'],
                     dog.user_choices[:jabber_to])
        assert_equal('woofer@jabber.org',
                     dog.user_choices[:jabber_account])
        assert_equal('Jpassword', dog.user_choices[:jabber_password])

        assert_equal(%w{this that and the other},
                     dog.user_choices[:command_to_watch])
      }
    end
  end


end
