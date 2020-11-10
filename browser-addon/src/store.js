import { v4 as uuid } from 'uuid'

const storage = browser.storage.local

export const addPacket = async ({ name, script, enabled = true, path }) => {
  const packet = { name, script, enabled, path }
  const key = uuid()

  const packets = await storage.get('packets')
  packets[key] = packet

  await storage.set({
    packets,
  })

  return {
    key,
    packet,
  }
}

export const getPacket = async key =>
  (await storage.get('packets')).packets[key]
