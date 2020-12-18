/**
 * API to get information from background script
 */

const sendPopupMessage = (type, payload) =>
  browser.runtime.sendMessage({
    scope: 'popup_message',
    type,
    payload,
  })

export const addPopupMessageListener = listener => {
  browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.scope === 'popup_message') {
      listener(message, sender, sendResponse)
    }
  })
}

export const removePopupMessageListener = listener => {
  browser.runtime.onMessage.removeListener(listener)
}

/**
 * Get all installed touchbar-packets
 * @return Promise a prosimse resolving to a list of touchbar-packets
 */
export const getTouchbarPackets = () => sendPopupMessage('get_touchbar_packets')
