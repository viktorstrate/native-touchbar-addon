import React from 'react'

import MenuItem from '../components/MenuItem'
import MenuLabel from '../components/MenuLabel'
import Separator from '../components/MenuSeparator'

const MainMenu = () => {
  return (
    <div>
      <MenuLabel>Active packet</MenuLabel>
      <MenuItem label="Packet name" navigateTo="/packet/PACKET_ID" />
      <Separator />
      <MenuItem label="Installed packets" navigateTo="/installed-packets" />
      <MenuItem label="New packet" />
      <MenuItem label="Settings" navigateTo="/settings" />
    </div>
  )
}

export default MainMenu
