/**
 * Entry point for background script
 * Configures and loads everything
 */

import { loadNativePort } from './nativeBridge'
import { loadTabManagement } from './tabManagement'
import { loadTouchbarPackets } from './touchbarPackets'
import { loadPopupAPI } from './popupApi'

const nativePort = browser.runtime.connectNative('touchbar_browser_helper')

console.log('background start')

loadTouchbarPackets()
loadPopupAPI()

loadTabManagement({ nativePort })
loadNativePort({ nativePort })
