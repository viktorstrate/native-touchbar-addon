browser.userScripts.onBeforeScript.addListener(script => {
  // const scriptMetadata = script.metadata

  console.log('script here', script)

  script.defineGlobals({
    touchbar: script.export({
      changeLayout: layout => {
        const changeLayoutMessage = {
          type: 'change_layout',
          layout,
        }

        browser.runtime.sendMessage({
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
          type: 'send_native_message',
          nativeMessage: updateItemMessage,
        })
      },
      addEventListener: listener => {
        browser.runtime.onMessage.addListener(message => {
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
