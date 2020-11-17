/**
 * Keeps the touch bar in sync with browser tabs
 */

let tabTouchbarLayouts = {}
let activeTouchbarTab = null

export const setTabTouchbarLayout = (tabId, layout) => {
  tabTouchbarLayouts[tabId] = layout
  activeTouchbarTab = tabId
}

export const updateTabTouchbarLayout = (tabId, name, changes) => {
  const itemIndex = tabTouchbarLayouts[tabId].findIndex(x => x.name == name)
  Object.assign(tabTouchbarLayouts[tabId][itemIndex], changes)
}

export const getActiveTouchbarTab = () => activeTouchbarTab

export const loadTabManagement = ({ nativePort }) => {
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
}
