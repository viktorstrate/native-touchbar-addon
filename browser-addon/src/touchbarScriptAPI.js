/**
 * API for touchbar packets
 */

browser.userScripts.onBeforeScript.addListener(script => {
  script.defineGlobals({
    touchbar: script.export({
      changeLayout: layout => {
        const changeLayoutMessage = {
          type: 'change_layout',
          layout,
        }

        browser.runtime.sendMessage({
          scope: 'native_bridge',
          type: 'send_native_message',
          nativeMessage: changeLayoutMessage,
        })
      },
      updateItem: (name, values) => {
        const updateItemMessage = {
          type: 'update_item',
          name,
          values,
        }

        browser.runtime.sendMessage({
          scope: 'native_bridge',
          type: 'send_native_message',
          nativeMessage: updateItemMessage,
        })
      },
      addEventListener: listener => {
        browser.runtime.onMessage.addListener(message => {
          if (message.scope != 'native_bridge_response') return
          listener(script.export(message))
        })
      },
    }),
  })

  console.log('custom userScripts APIs defined')
})

console.log(
  'apiScript executed and userScripts.onBeforeScript listener subscribed'
)
