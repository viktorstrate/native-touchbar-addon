# Native Touchbar Addon

Native macOS touchbar controls for webpages

<img width="720" src="demo.gif">

## How it works

The project consists of two parts, a regular browser extension and a native binary that controls the touchbar.
The two parts communicate back and fourth using [Native Messaging](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging).

The browser extension exposes a bridging API to small JavaScript scripts that are injected into webpages using [URL pattern matching](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/content_scripts#Matching_URL_patterns).
These small scripts are called [touchbar packets](./browser-addon/src/touchbar-packets/), and are formatted much like [Userscripts](https://en.wikipedia.org/wiki/Userscript), with a header describing the name of the packet and one or more url matches.

The binary is a small CLI app written mostly in Swift, its purpose is to receive configurations for the touchbar from the browser extension, update the touchbar accordingly and send any user interaction events back to the browser.
The binary uses a private system API to show the new touchbar on top of the original. Thanks to [Touch Bär](https://github.com/a2/touch-baer).


