<img src="https://raw.github.com/briangonzalez/cocoa-rack/master/server/public/images/icon.png" width=30 style="margin-right: 10px">  cocoa-rack
======================================

Run [rack](http://rack.github.io/) apps within Mac apps.


Try example app
------------
Fire up your terminal and run the following. This will clone the repo and run the example bundled application.

```bash
# Clone the repo.
git clone git@github.com:briangonzalez/cocoa-rack.git

# Unzip.
unzip cocoa-rack/build/talk.zip

# Open the app.
open cocoa-rack/build/talk.app
```

How does it work?
-------------------
cocoa-rack uses some pretty cool technologies to run rack apps within a webview. cocoa-rack will first try to launch your rack app using OSX's system Ruby; if said Ruby is not found, a fallback is used: an awesome contained Ruby called [JRuby Complete](http://www.jruby.org/download). A little hacky, but all works in the end.

Once up and running, the app bundled with the repository, **TalkApp**, uses POST calls to communicate with the rack server, which in turn makes OSX system calls. In this case, the command `say` is used to speak text in which the user has typed in. 


Disclaimer
-----------
Very beta at the moment, and there are a lot of undocumented and seemingly confusing aspects to rack-cocoa, but trust me, it's very simple. In theory, you should never need to touch Objective-C code. 

Demo
-----
The following gif shows the app bundled with this repo, called **TalkApp**, which speaks text which you type. Follow the directions above to try it out.
<img src="https://raw.github.com/briangonzalez/cocoa-rack/master/server/public/images/cocoa-rack.gif">

About & Credits
------------------
Hacked together by [@brianmgonzalez](http://twitter.com/brianmgonzalez). Icon from [The Noun Project](http://thenounproject.com/noun/coffee-bean/#icon-No2006) by [Randall Barriga](http://thenounproject.com/randy).
