
browser.userScripts.onBeforeScript.addListener(script => {

    script.defineGlobals({
      GLOBAL_VALUE: 'This is an API value'
    })

})
