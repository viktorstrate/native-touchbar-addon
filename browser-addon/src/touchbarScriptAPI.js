browser.userScripts.onBeforeScript.addListener(script => {
  // const scriptMetadata = script.metadata

  console.log('script here', script)

  script.defineGlobals({
    touchbar: script.export({
      changeLayout: layout => {
        const filteredLayout = layout.map(x => ({
          type: x.type,
          name: x.name,
          label: x.label,
        }))

        const changeLayoutMessage = {
          type: 'change_layout',
          layout: filteredLayout,
        }

        browser.runtime.sendMessage({
          message: {
            type: 'send_native_message',
            nativeMessage: changeLayoutMessage,
          },
        })
      },
      addEventListener: browser.runtime.onMessage.addListener,
    }),
  })

  console.log('custom userScripts APIs defined')
})

console.log(
  'apiScript executed and userScripts.onBeforeScript listener subscribed'
)
