/**
 * Load native binary and communication to and from it
 */

import * as tabManagement from './tabManagement'

export const loadNativePort = ({ nativePort }) => {
  nativePort.onDisconnect.addListener(p => {
    if (p.error) {
      console.log(`Disconnected due to an error: ${p.error.message}`)
    }
  })

  browser.runtime.onMessage.addListener((message, sender) => {
    if (message.scope != 'native_bridge') return

    if (message.type == 'send_native_message') {
      if (message.nativeMessage.type == 'change_layout') {
        tabManagement.setTabTouchbarLayout(
          sender.tab.id,
          message.nativeMessage.layout
        )
      }

      if (message.nativeMessage.type == 'update_item') {
        console.log('update item save state')

        tabManagement.updateTabTouchbarLayout(
          sender.tab.id,
          message.nativeMessage.name,
          message.nativeMessage.values
        )
      }

      // Only update touchbar if tab is active
      browser.tabs
        .query({ active: true, windowId: browser.windows.WINDOW_ID_CURRENT })
        .then(tabs => browser.tabs.get(tabs[0].id))
        .then(activeTab => {
          if (activeTab.id === sender.tab.id) {
            console.log('sending native message', message.nativeMessage)
            nativePort.postMessage(message.nativeMessage)
          }
        })
    }
  })

  nativePort.onMessage.addListener(response => {
    console.log('Received', response)

    const activeTouchbarTab = tabManagement.getActiveTouchbarTab()

    if (activeTouchbarTab) {
      console.log('sending message to tab', activeTouchbarTab)
      browser.tabs.sendMessage(activeTouchbarTab, {
        ...response,
        scope: 'native_bridge_response',
      })
    }
  })
}
