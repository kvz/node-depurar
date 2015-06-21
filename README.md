# depurar

<!-- badges/ -->
[![Build Status](https://travis-ci.org/kvz/node-depurar.svg?branch=master)](https://travis-ci.org/kvz/node-depurar)
[![Build Status](https://img.shields.io/travis/kvz/node-depurar/master.svg)](http://travis-ci.org/kvz/node-depurar) 
[![Coverage Status](https://coveralls.io/repos/kvz/node-depurar/badge.svg)](https://coveralls.io/r/kvz/node-depurar)
[![npm](https://img.shields.io/npm/v/depurar.svg)](https://www.npmjs.com/package/depurar) 
[![Dependency Status](https://david-dm.org/kvz/node-depurar.png?theme=shields.io)](https://david-dm.org/kvz/node-depurar)
[![Development Dependency Status](https://david-dm.org/kvz/node-depurar/dev-status.png?theme=shields.io)](https://david-dm.org/kvz/node-depurar#info=devDependencies)
<!-- /badges -->


> **depurar** (first-person singular present indicative depuro, past participle depurado)  
> 1. to purify, cleanse  
> 2 (computing) To debug  

Depurar is a wrapper around [`debug`](https://www.npmjs.com/package/debug) adding a couple
of features for the truly lazy.

## Install

```bash
npm install --save depurar
```

## Added features

### Automatically establish namespace 

`debug` has the convention of prefixing debug output with a namespace in the form of: `Library:feature`. This allows us to quickly enable/disable debug output for some libraries or features. In my interpretation of this convention this often leads to `ModuleName:ClassName`.

So I got a bit tired of opening `~/code/foo/lib/Bar.coffee` and typing:

```coffeescript
debug = require("debug")("foo:Bar")
class Bar
  constructor: ->
    debug "ohai"
```

With Depurar, the second part will be based on the basename of the file where you require it:

```coffeescript
debug = require("depurar")("foo")
# Sets the namespace to `foo:Bar` in the case of `~/code/foo/lib/Bar.coffee`
```

What's more, if you are really truly lazy, the first part of this namespace can even be [guessed](https://www.npmjs.com/package/app-root-path) based on the directory name of your library/app, and 

```coffeescript
debug = require("depurar")()
# Sets the namespace to `foo:Bar` in the case of `~/code/foo/lib/Bar.coffee`
```

### Pick color based on namespace, not rotation

`debug` by default picks the next color from a list, every time it gets instantiated. That's nice so you get a new color for every entity that's talking to you. However in async land this also often means that with every run or change, every entity has a new color again. First world's problems but the brain is great at recognizing patterns via color and so if every entity had it's own color, debug information would be easier to digest.

That's the reasoning. And that's why Depurar reduces namespaces to a color index via crc. This does not warrant unique colors across the board, but it does make every class or feature, always speak in the same color.

![](https://dl.dropboxusercontent.com/s/45um101fayesfl3/2015-06-20%20at%2013.41.png?dl=0)


## FAQ

### Is Depurar more efficient than debug?

While I'm too lazy to benchmark, considering there's extra pathfinding and computation involved, I'd say: No.
If your app's bottleneck is in requiring files, Depurar is not for you. That said, if the bottleneck in your
app becomes Depurar, I'd either be very impressed or underwhelmed by your app.

## Todo

- [ ] Support for enabling adding the linenumber to the debug prefix
- [ ] Support for disabling colorpicking by namespace
- [ ] Handle & test the case where `undefined` is debugged


## Sponsor Development

Like this project? Consider a donation.

<!-- badges/ -->
[![Gittip donate button](http://img.shields.io/gittip/kvz.png)](https://www.gittip.com/kvz/ "Sponsor the development of depurar via Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](https://flattr.com/submit/auto?user_id=kvz&url=https://github.com/kvz/depurar&title=depurar&language=&tags=github&category=software "Sponsor the development of depurar via Flattr")
[![PayPal donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=kevin%40vanzonneveld%2enet&lc=NL&item_name=Open%20source%20donation%20to%20Kevin%20van%20Zonneveld&currency_code=USD&bn=PP-DonationsBF%3abtn_donate_SM%2egif%3aNonHosted "Sponsor the development of depurar via Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/19BtCjLCboRgTAXiaEvnvkdoRyjd843Dg2 "Sponsor the development of depurar via BitCoin")
<!-- /badges -->
