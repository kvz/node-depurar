# depurar

<!-- badges/ -->
[![Build Status](https://travis-ci.org/kvz/node-depurar.svg?branch=master)](https://travis-ci.org/kvz/node-depurar)
[![NPM version](http://badge.fury.io/js/depurar.png)](https://npmjs.org/package/depurar "View this project on NPM")
[![Dependency Status](https://david-dm.org/kvz/depurar.png?theme=shields.io)](https://david-dm.org/kvz/depurar)
[![Development Dependency Status](https://david-dm.org/kvz/depurar/dev-status.png?theme=shields.io)](https://david-dm.org/kvz/depurar#info=devDependencies)
<!-- /badges -->


> **depurar** (first-person singular present indicative depuro, past participle depurado)
> 1. to purify, cleanse  
> 2 (computing) To debug  

depurar is a wrapper around [`debug`](https://www.npmjs.com/package/debug) adding a couple
of features for the truly lazy.

## Install

```bash
npm install --save depurar
```

## Added features

### Automatically establishes namespace 

`debug` has the convention of prefixing debug output with a namespace in the form of: `Library:feature`. This allows us to quickly enable/disable debug output for some libraries or features. In my interpretation of this convention this often leads to `ModuleName:ClassName`.

So I got a bit tired of opening `~/code/foo/lib/Bar.coffee` and typing:

```coffeescript
debug = require("debug")("foo:Bar")
class Bar
  constructor: ->
    debug "ohai"
```

with depurar, the first part of this namespace will be [guessed](https://www.npmjs.com/package/app-root-path) based on the directory name of your library/app, and the second part will be based on the basename of the file where you require it:

```coffeescript
debug = require("depurar")()
```

Saving you some precious keystrokes : )

If you don't like the automatic guessing of the library name, you can also just litter your project with:

```coffeescript
debug = require("depurar")("foo")
```

causing only the second `Bar` part to be automatically established.

### Picks color based on namespace, not rotation

Debug by default picks the next color from a list, every time it gets instantiated. While there are certainly advantages to that, that depurar is killing, depurar bases the color picked on the namespace.

The the thing about this is that particular classes will always talk to you in the same color, making it easy for your brain to digest. "Ah pink, that's `Bar` alright. "

![](https://dl.dropboxusercontent.com/s/45um101fayesfl3/2015-06-20%20at%2013.41.png?dl=0)

## Sponsor Development

Like this project? Consider a donation.

<!-- badges/ -->
[![Gittip donate button](http://img.shields.io/gittip/kvz.png)](https://www.gittip.com/kvz/ "Sponsor the development of depurar via Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](https://flattr.com/submit/auto?user_id=kvz&url=https://github.com/kvz/depurar&title=depurar&language=&tags=github&category=software "Sponsor the development of depurar via Flattr")
[![PayPal donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=kevin%40vanzonneveld%2enet&lc=NL&item_name=Open%20source%20donation%20to%20Kevin%20van%20Zonneveld&currency_code=USD&bn=PP-DonationsBF%3abtn_donate_SM%2egif%3aNonHosted "Sponsor the development of depurar via Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/19BtCjLCboRgTAXiaEvnvkdoRyjd843Dg2 "Sponsor the development of depurar via BitCoin")
<!-- /badges -->
