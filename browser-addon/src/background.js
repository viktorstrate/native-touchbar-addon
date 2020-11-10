import * as store from './store'

const nativePort = browser.runtime.connectNative('touchbar_browser_helper')

console.log('background start')

let activeTouchbarTab = null

const packet = store.addPacket({
  name: 'test',
  enabled: true,
  script: '// hello world',
  path: 'google.com',
})

packet.then(x => {
  console.log('packet', x)

  store.getPacket(x.key).then(console.log)
})

console.log('native port', nativePort)

nativePort.onDisconnect.addListener(p => {
  if (p.error) {
    console.log(`Disconnected due to an error: ${p.error.message}`)
  }
})

browser.runtime.onMessage.addListener(({ message }, sender, sendResponse) => {
  console.log('runtime message', sender, sendResponse)

  activeTouchbarTab = sender.tab

  if (message.type == 'send_native_message') {
    console.log('sending native message', message.nativeMessage)
    nativePort.postMessage(message.nativeMessage)
  }
})

nativePort.onMessage.addListener(response => {
  console.log('Received', response)

  if (activeTouchbarTab) {
    console.log('sending message to tab', activeTouchbarTab)
    browser.tabs.sendMessage(activeTouchbarTab.id, {
      type: 'action',
      name: response.name,
    })
  }
})
;(async function () {
  console.log('async userscript')

  const youtubePacketCode = `(async function () {
    console.log("USER SCRIPT EXECUTING on", window.location.href);

    touchbar.changeLayout([
      {
        type: 'button',
        name: 'browser-button',
        label: window.location.host,
        action: () => ('hello')
      }
    ])

    touchbar.addEventListener(message => {
      console.log('received client event', message)
      document.body.innerHTML = \`<h1>This page has been eaten</h1>\`
    })

  })();`

  console.log('youtube code', youtubePacketCode)

  const result = await browser.userScripts.register({
    matches: ['<all_urls>'],
    js: [
      {
        code: youtubePacketCode,
      },
    ],
    scriptMetadata: {},
  })

  console.log('script registered', result)
})()

console.log('background end')
