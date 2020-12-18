import React, { useContext } from 'react'
import { PopupContext } from '../app'

import MenuItem from '../components/MenuItem'

const InstalledPackets = () => {
  const popup = useContext(PopupContext)

  const packets = popup.touchbarPackets.map((packet, idx) => (
    <MenuItem key={idx} label={packet.headers.name} />
  ))

  return <div>{packets}</div>
}

export default InstalledPackets
