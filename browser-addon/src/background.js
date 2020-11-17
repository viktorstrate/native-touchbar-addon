import { loadNativePort } from './nativeBridge'
import { loadTabManagement } from './tabManagement'
import { loadTouchbarPackets } from './touchbarPackets'

const nativePort = browser.runtime.connectNative('touchbar_browser_helper')

console.log('background start')

loadTouchbarPackets()

loadTabManagement({ nativePort })
loadNativePort({ nativePort })
