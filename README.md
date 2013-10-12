<img src="https://raw.github.com/briangonzalez/cocoa-rack/master/server/public/images/icon.png" width=30 style="margin-right: 10px">  cocoa-rack
======================================

Run [rack](http://rack.github.io/) apps natively on OSX.


Try it Out
------------
Fire up your terminal and run:

```bash
# Clone the repo.
git clone git@github.com:briangonzalez/cocoa-rack.git

# Open the app.
open cocoa-rack/build/cocoa-rack.app
```

How does it work?
-------------------
cocoa-rack uses some pretty cool technologies to run rack apps within a webview. cococa-rack will first try to launch your rack app using OSX's system Ruby; if sais Ruby is now found, we fall back to an awesome contained Ruby call [JRuby Complete](http://www.jruby.org/download). A little hacky, but all works in the end.


Disclaimer
-----------
Very beta at the moment, and there are a lot of undocumented and seemingly confusing aspects to rack-cocoa, but trust me, it's very simple. In theory, you should never need to touch Objective-C code. 

Demo
-----
The following gif shows the app bundled with this repo, called TalkApp, which speaks text which you type. Follow the directions above to try it out.
<img src="https://raw.github.com/briangonzalez/cocoa-rack/master/server/public/images/cocoa-rack.gif">

About
-------
Hacked together by [@brianmgonzalez](http://twitter.com/brianmgonzalez).
