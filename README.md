shoutcast-irc
=============

a simple but nice shoutcast-to-irc announcer bot.

copyleft (c) 2012 alexander schoedon, donc_oe@qhor.net


functionality
-------------

the bot is able to:

 * connect to an irc network and join channels
 * read statusinformation of a shoutcast server (**shoutcast v1 only!**)
    * stream title 
    * server status (online/offline)
    * song artist and title
    * current, peak and max listeners
    * bitrate
 * announce stream, song and server status to irc channels on request
 * change topic of channels automatically on server status change

to see a demo version of this bot running, join `#punkrockers` on
`irc.jxceldolghmq.net` and type `.help` - this is my bot. :)

thanks to the jdq and punkrockers crew at this point.


license
-------

this program is free software: you can redistribute it and/or modify it under
the terms of the gnu general public license as published by the free software
foundation, either version 3 of the license, or (at your option) any later
version.

this program is distributed in the hope that it will be useful, but without
any warranty; without even the implied warranty of merchantability or fitness
for a particular purpose. see the gnu general public license for more
details.

you should have received a copy of the gnu general public license along with
this program. if not, see <http://www.gnu.org/licenses/>.


latest version
--------------

the latest version is available at github:

 * <https://github.com/donschoe/shoutcast-irc>


dependencies
------------

`shoutcast-irc` is a `ruby` script depending on `rubygems`. install at least
`ruby-1.9.3` and `rubygems-1.8.24`.

the following gems are required:

 * `net-irc-0.0.9` or better
 * `xml-simple-1.1.0` or better
 * `mechanize-2.3.0` or better


setup and running
-----------------

 * install the required dependences
 * read comments and adjust settings in `start.rb`
 * run `start.rb`

on irc type `.help` to get information about available commands.


further notes
-------------

the bot only supports shoutcast-v1 servers. v2 is not supported.

the bot has to have its own registered nick on the irc network
because it will take care of some specified channels (admin channel,
main channel). grant operator rights for the bot in these two
channels.

add as many additional channels as required to the idle-channels
list. the bot wont do any stuff in these channel untill requested 
to do so.

the bot will update topics in admin and main channel if stream status
changes. modify the strings in `start.rb`. modify any string you want
in `start.rb` if you need to.

if you need support post an issue on github or send me a mail.


changelog
---------

0.2.3: (2012-08-15)
 * fixing the .status bug introduced in e41ab74
 * fixing the topic-autoupdate bug introduced in e41ab74

0.2.2: (2012-08-11)
 * using /usr/bin/env to get rubies outside the usual path and load instead
   of require so it looks in the right place for includes
 * switching to mechanize and utilizing the xml interface for server
   information

0.2.1: (2012-08-11)
 * fixed stream title string parser
 
0.2.0: (2012-08-10)
 * first public version, hf

0.1.0-dev: (2012-08-09)
 * complete code clean-up
 * class `ScBot` re-written (and moved to `inc/scbot.rb`)
 * configuration via `start.rb` possible

0.0.5-dev: (2012-08-09)
 * fixed typo

0.0.4-dev: (2012-08-09)
 * topic now being changed automatically
 * improved variables

0.0.3-dev: (2012-08-09)
 * added stream-title-parser
 * added topic-changer
 * improved status messages

0.0.2-dev: (2012-08-09)
 * fixed calculation of current listeners

0.0.1-dev: (2012-08-06)
 * initial commit of the basic script


contributors
------------

 * donSchoe, donc_oe@qhor.net
 * v2px, v2px@v2px.de
