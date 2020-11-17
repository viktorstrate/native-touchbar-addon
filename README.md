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

## Installing

### Build and install the binary

Clone the repository, and navigate into it.

```sh
$ git clone https://github.com/viktorstrate/native-touchbar-addon
$ cd native-touchbar-addon
```

Make sure you have the newest version of Xcode installed.
Then run the following command to build and install the binary.

Alternatively you can open the xcode project and click on `Product` -> `Build`

```sh
$ xcodebuild -scheme touchbar-browser-helper
```

This will build the binary and copy it to `~/Library/Application Support/touchbar-browser-helper/`

### Configure the Native Messaging Host

Next we need to tell Firefox where the binary is located.
To do this, copy the [touchbar-browser-helper.json](./browser-addon/touchbar_browser_helper.json) file to `~/Library/Application Support/Mozilla/NativeMessagingHosts/`. Then change the path attribute in the json file to match the username of your account.

You can do all this by run the following commands.

```sh
$ mkdir -p ~/Library/Application\ Support/Mozilla/NativeMessagingHosts/
$ cp ./browser-addon/touchbar_browser_helper.json ~/Library/Application\ Support/Mozilla/NativeMessagingHosts/
$ sed -i '' "s/YOUR_USERNAME/$USER/g" ~/Library/Application\ Support/Mozilla/NativeMessagingHosts/touchbar_browser_helper.json
```

### Install the browser extension

Install the browser extension from 
https://addons.mozilla.org/en-US/firefox/addon/native-touchbar/

The extension will automatically start the helper program in the background.
