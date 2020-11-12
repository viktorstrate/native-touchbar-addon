import { loadTouchbarPackets } from './touchbarPackets'

const nativePort = browser.runtime.connectNative('touchbar_browser_helper')

console.log('background start')

loadTouchbarPackets()

let tabTouchbarLayouts = {}
let activeTouchbarTab = null

// Native bridge
console.log('native port', nativePort)

nativePort.onDisconnect.addListener(p => {
  if (p.error) {
    console.log(`Disconnected due to an error: ${p.error.message}`)
  }
})

browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
  console.log('runtime message', sender, sendResponse)

  if (message.type == 'send_native_message') {
    console.log('sending native message', message.nativeMessage)

    if (message.nativeMessage.type == 'change_layout') {
      tabTouchbarLayouts[sender.tab.id] = message.nativeMessage.layout
      activeTouchbarTab = sender.tab.id
    }

    nativePort.postMessage(message.nativeMessage)
  }
})

nativePort.onMessage.addListener(response => {
  console.log('Received', response)

  if (activeTouchbarTab) {
    console.log('sending message to tab', activeTouchbarTab)
    browser.tabs.sendMessage(activeTouchbarTab, response)
  }
})

// Tab management
browser.tabs.onRemoved.addListener(({ tabId }) => {
  console.log('tab closed cleaning up', tabId)
  tabTouchbarLayouts[tabId] = undefined
})

browser.tabs.onActivated.addListener(({ tabId }) => {
  console.log('tab activated')
  if (tabTouchbarLayouts[tabId]) {
    console.log('tab changed changing layout', tabId)

    activeTouchbarTab = tabId

    nativePort.postMessage({
      type: 'change_layout',
      layout: tabTouchbarLayouts[tabId],
    })
  } else {
    console.log('close touchbar')
    activeTouchbarTab = null
    nativePort.postMessage({
      type: 'dismiss_touchbar',
    })
  }
})

// Reset touchbar if domain changes
browser.tabs.onUpdated.addListener(async (tabId, changes, tab) => {
  if (changes.url) {
    console.log('getting old url')
    const oldUrl = await browser.sessions.getTabValue(tabId, 'configured_url')

    console.log('got old url', oldUrl)

    if (oldUrl) {
      const oldHost = new URL(oldUrl).host
      const newHost = new URL(changes.url).host

      console.log('url changed', oldUrl, tab.url)

      if (oldHost != newHost) {
        console.log('url host changed')
        nativePort.postMessage({
          type: 'dismiss_touchbar',
        })
      }
    }

    browser.sessions.setTabValue(tabId, 'configured_url', changes.url)
  }
})
