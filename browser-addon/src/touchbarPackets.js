export function parseTouchbarPacket(packet) {
  const [_, header, body] = packet.match(
    /^[\n\s]*\/\/\s+==TouchbarPacket==([^]+)==\/TouchbarPacket==\n([^]+)/
  )

  const headerFields = header
    .match(/@\w+\s.+/g)
    .map(fieldLine => {
      const [_, key, value] = fieldLine.match(/@(\w+)\s(.+)/)
      return [key, value]
    })
    .reduce((result, field) => {
      if (result[field[0]]) {
        result[field[0]].push(field[1])
      } else {
        result[field[0]] = [field[1]]
      }
      return result
    }, {})

  return {
    headers: headerFields,
    script: body,
  }
}

export const touchbarPackets = [
  require('./touchbar-packets/youtube.touchbar-packet'),
  require('./touchbar-packets/github.touchbar-packet'),
  require('./touchbar-packets/google.touchbar-packet'),
  require('./touchbar-packets/facebook.touchbar-packet'),
].map(parseTouchbarPacket)

export const loadTouchbarPackets = async function () {
  const packetRegisterPromises = touchbarPackets.map(packet => {
    return browser.userScripts.register({
      matches: packet.headers.match,
      js: [
        {
          code: packet.script,
        },
      ],
      scriptMetadata: {},
    })
  })

  await Promise.all(packetRegisterPromises)

  console.log('All touchbar packets loaded')
}
