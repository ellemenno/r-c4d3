# make games. share games. play games. #
## purpose ##
provide simple, useful tools for video game development, deployment, and play

  * _**make**_  - use the light-weight framework to skip the small stuff and focus on the game. easily deploy stand-alone games on the desktop, online, or as part of the r-c4d3 portal community.
  * _**share**_ - a common core api makes games loadable on any device the romloaders are ported to, to help make your games available for online play or download. set up your own game portal to share your games with others. rate games and comment on them.
  * _**play**_  - play individual games online. collect roms and launch them on your desktop with a common loader. run the desktop shell to access a game portal and play games on online, aggregated from multiple portals.

## status: _alpha_ ##
the r-c4d3 project is stabilizing. the core api, framework, romloaders and rom examples are usable and ready for comments and issue logging. the framework may still experience some significant changes to its components as the best ways of structuring the complementary parts are worked out. see the [RoadMap](RoadMap.md) for what's planned.

the current focus is on actionscript game development and web and desktop (win/osx) deployment, other technologies (java, javascript+canvas, etc.) and operating systems will be given more attention and example implementations in later phases of the project.

## components ##
|_framework_|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png)|Code to make writing games a little easier|
|:----------|:----------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------|
|_gamerom api_|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png)|Standard API to simplify cross-device adoption|
|_installation_|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-err.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-err.png)|The r-c4d3 system in a precompiled package|
|_menu_     |![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-err.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-err.png)|Front end for the r-c4d3 system; shows game icons and launches games|
|_menushell_|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-warn.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-warn.png)|Desktop executable web broswer shell that loads the menu.html|
|_romloader_|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png)|Reusable loaders for game roms implementors; encapsulates config, control and  score access|
|_roms_     |![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png)|Various demos that ship with the r-c4d3 system|
|_scoreserver_|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-warn.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-warn.png)|A simplistic high score server            |
|_shared_   |![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png)|Resources used by multiple components     |

|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-ok.png)|ready for comments|
|:----------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|
|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-warn.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-warn.png)|needs work        |
|![http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-err.png](http://r-c4d3.googlecode.com/svn/trunk/shared/src/icons/status-err.png)|not addressed yet |

## stats ##
| &lt;wiki:gadget url="http://www.ohloh.net/p/379381/widgets/project\_basic\_stats.xml" height="250" width="290" border="0" /&gt; | &lt;wiki:gadget url="http://www.ohloh.net/p/379381/widgets/project\_factoids.xml" height="250" width="320" border="0" /&gt; |
|:--------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|