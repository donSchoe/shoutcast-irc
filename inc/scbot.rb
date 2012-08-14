#!/usr/bin/ruby

###########################################################
#                                                         #
#                SHOUTCAST-IRC v0.2.0-dev                 #
#                                                         #
###########################################################
#                                                         #
#    a simple but nice shoutcast-to-irc announcer bot.    #
# copyleft (c) 2012 alexander schoedon <donc_oe@qhor.net> #
#       <https://github.com/donSchoe/shoutcast-irc>       #
#                                                         #
###########################################################

$LOAD_PATH << "lib"
$LOAD_PATH << "../lib"

require 'rubygems'
require 'net/irc'
require 'open-uri'
require 'pp'
require 'mechanize'
require 'xmlsimple'

class ScBot < Net::IRC::Client

  attr_accessor :sc_server
  attr_accessor :sc_port
  attr_accessor :chan_admin
  attr_accessor :chan_main
  attr_accessor :chans_idle
  attr_accessor :topic_on
  attr_accessor :topic_off
  attr_accessor :topic_admin
  attr_accessor :help_msg
  attr_accessor :help_admin
  attr_accessor :title
  attr_accessor :title_old
  attr_accessor :status
  attr_accessor :status_old
  attr_accessor :cmd_prr
  attr_accessor :cmd_status
  attr_accessor :cmd_stream
  attr_accessor :st_online
  attr_accessor :st_offline
  attr_accessor :st_np
  attr_accessor :st_lstnrs
  attr_accessor :xml
  
  def set_sc_servers(sc_server, sc_port, sc_password)
    @sc_server = sc_server
    @sc_port = sc_port
		@sc_password = sc_password
		@agent.add_auth("http://#{@sc_server}:#{@sc_port}/admin.cgi?mode=viewxml", "admin", @sc_password)
  end
  
  def set_ircdetails(c_admin, c_main, c_idle, t_on, t_off, t_admin, h_msg,
                     h_admin, stream, st_online, st_offline, now_playing,
										 listeners)
    @chan_admin = c_admin
    @chan_main = c_main
    @chans_idle = c_idle
    @topic_on = t_on
    @topic_off = t_off
    @topic_admin = t_admin
    @help_msg = h_msg
    @help_admin = h_admin
    @cmd_stream = stream
    @st_online = st_online
    @st_offline = st_offline
		@st_np = now_playing
		@st_lstnrs = listeners
		@xml = nil
  end

  def initialize(*args)
    super

		@agent = Mechanize.new
		@agent.user_agent_alias = 'Linux Firefox'
  end
  
  def on_ping(m)
    post PONG, @prefix ? @prefix.nick : m[0]
  end

  def on_rpl_welcome(m)
    join_channels
    post_welcome
		Thread.new do
			update_sc_status
			update_topic
			loop do
				auto_update_topic
			end
		end
  end

  def join_channels
    sleep 2
    post JOIN, @chan_admin
    post JOIN, @chan_main
    @chans_idle.each do |chan|
      post JOIN, chan
    end
  end

  def post_welcome
    post PRIVMSG, @chan_admin, @help_admin
    post PRIVMSG, @chan_main, @help_msg
  end

  def auto_update_topic ### @todo doesnt work anymore!
    @title_old = @xml["SERVERTITLE"].first
    @status_old = @xml["STREAMSTATUS"].first.to_i
    sleep 60
    update_sc_status
    if @title_old != @xml["SERVERTITLE"].first || @status_old != @xml["STREAMSTATUS"].first.to_i
      update_topic(false)
    end
  end

  def update_topic(update=false)
    if udpate
      update_sc_status
    end
    if @xml["STREAMSTATUS"].first.to_i == 1
      post TOPIC, @chan_main, @st_online + ': ' + @xml["SERVERTITLE"].first + @topic_on.to_s
      post TOPIC, @chan_admin, @st_online + ': ' + @xml["SERVERTITLE"].first + @topic_admin.to_s
    else
      post TOPIC, @chan_main, @st_offline + @topic_off.to_s
      post TOPIC, @chan_admin, @st_offline + @topic_admin.to_s
    end
  end

  def on_privmsg(m)
    if m[1] == '.help'
      if m[0] == @chan_main
        post PRIVMSG, @chan_main, @help_msg
      elsif m[0] == @chan_admin
        post PRIVMSG, @chan_admin, @help_admin
      else
        post PRIVMSG, m[0], @help_msg
      end
    elsif m[1] == '.np'
      update_sc_status
			if @xml["STREAMSTATUS"].first.to_i == 1
	      post PRIVMSG, m[0], "#{@st_np}: #{@xml["SONGTITLE"].first} (#{@xml["SERVERTITLE"].first}: #{@xml["CURRENTLISTENERS"].first} #{@st_lstnrs})"
			else
				post PRIVMSG, m[0], @st_offline
			end
    elsif m[1] == '.stream'
      post PRIVMSG, m[0], @cmd_stream
    elsif m[1] == '.status'
      if m[0] == @chan_admin
        update_sc_status
        post PRIVMSG, @chan_admin, @cmd_status ### @todo this is empty!
      end
    elsif m[1] == '.topic'
      if m[0] == @chan_admin
        update_topic(true)
      end
    end
  end

  def update_sc_status
		page = @agent.get("http://#{@sc_server.to_s}:#{@sc_port.to_s}/admin.cgi?mode=viewxml")
		@xml = XmlSimple.xml_in(page.body)
  end
end
