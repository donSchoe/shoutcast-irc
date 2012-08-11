#!/usr/bin/env ruby

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

$LOAD_PATH << "./lib"
$LOAD_PATH << "../lib"

require 'rubygems'
load 'inc/scbot.rb'

### SHOUTCAST-v1 SETTINGS #################################
sc_server = '123.456.789.0'    # shoutcast server adress
sc_port = '8000'               # shoutcast server port
sc_password = ''
###########################################################

### IRC SERVER SETTINGS ###################################
server = 'irc.example.net'     # irc server address
port = '6667'                  # irc server port
nick = 'botnick'               # nickname of the bot
password = 'botpass'           # password of the bot (required, see README)
user_name = 'botuser'          # username of the bot
real_name = 'Ingo the Bot'     # realname of the bot
# the admin channel is the control center of the bot.
# channel should be mode +Rsi. make sure the bot gets auto-op on join.
admin_chan = '#admin-channel'
# the main channel is the where the bot controls topic etc.
# make sure the bot gets auto-op on join.
main_chan = '#main-channel'
# add other channels to join. in this channels the bot wont change topic
# or post any messages when not requested to do so.
idle_chans = ['#channel-1', '#channel-2', '#channel-3']
###########################################################

### CUSTOM STRING SETTINGS ################################
# topic for the main channel when shoutcast-stream is online.
# will look like 'Stream online: <current show> | This is the online topic string.'
online_topic = ' | This is the online topic string.'
# topic for the main channel when shoutcast-stream is offline.
# will look like 'Stream offline | This is the offline topic string.'
offline_topic = ' | This is the offline topic string.'
# topic for the admin channel. will look like:
# 'Stream <status> | This is the admin topic string.'
admin_topic = ' | This is the admin topic string.'
# welcome and help message for the main and idle channels. 
help_msg = 'Type .np for current song or .stream for stream-url.'
# welcome and help message for the admin channel. 
help_admin = 'Type .status for detailed information and .topic to update topics.'
# string telling the users where to find the stream
stream = 'Stream URL: http://example.com/listen.pls'
# string of the server status 1
st_online = 'Stream online'
# string of the server status 0
st_offline = 'Stream OFFLINE'
# now playing string, modify to translate
now_playing = 'Now playing'
# listeners string, modify to translate
listeners = 'listeners'
###########################################################

bot = ScBot.new(server, port, { :pass => password,
                                :nick => nick,
                                :user => user_name,
                                :real => real_name, } )
bot.set_sc_servers(sc_server, sc_port, sc_password)
bot.set_ircdetails(admin_chan, main_chan, idle_chans, online_topic,
                   offline_topic, admin_topic, help_msg, help_admin, stream,
                   st_online, st_offline, now_playing, listeners)
bot.start
