console.log('background start')

/*
On startup, connect to the "touchbar-browser-helper" app.
*/
var port = browser.runtime.connectNative("touchbar_browser_helper");

console.log('native port', port)

port.onDisconnect.addListener((p) => {
  if (p.error) {
    console.log(`Disconnected due to an error: ${p.error.message}`);
  }
});

/*
Listen for messages from the app.
*/
port.onMessage.addListener((response) => {
  console.log("Received", response);
});

/*
On a click on the browser action, send the app a message.
*/
browser.browserAction.onClicked.addListener(() => {
  console.log("Sending:  button layout");

  const touchbarLayout = {
    type: 'change_layout',
    layout: [
      {
        type: 'button',
        name: 'browser-button',
        label: 'From the browser 🥳',
      }
    ]
  }

  const ping = {
    type: 'ping'
  }

  port.postMessage(touchbarLayout);
});

console.log('background end')
