import { touchbarPackets } from './touchbarPackets'

/**
 * API for popup to get information from background script
 */

const sendPopupMessage = (type, payload) =>
  browser.runtime.sendMessage({
    scope: 'popup_message',
    type,
    payload,
  })

export const loadPopupAPI = () => {
  browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.scope != 'popup_message') return

    switch (message.type) {
      case 'get_touchbar_packets':
        sendResponse(touchbarPackets)
    }
  })
}

export const activePacketChanged = newActivePacket => {
  sendPopupMessage('active_packet_changed', newActivePacket)
}
