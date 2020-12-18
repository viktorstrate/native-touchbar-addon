import React, { useState, useEffect } from 'react'
import ReactDOM from 'react-dom'
import { createGlobalStyle } from 'styled-components'
import { MemoryRouter as Router, Route, Switch } from 'react-router-dom'
import MainMenu from './routes/MainMenu'
import NavigationHeader from './components/NavigationHeader'
import {
  addPopupMessageListener,
  getTouchbarPackets,
  removePopupMessageListener,
} from './backgroundApi'
import InstalledPackets from './routes/InstalledPackets'

const GlobalStyles = createGlobalStyle`
  body {
    margin: 0;
    padding: 0;

    width: 100%;
    min-width: 360px;
  }
`

export const PopupContext = React.createContext({
  touchbarPackets: [],
})

const SubRoutes = route => (
  <div>
    <Switch>
      <Route path="/installed-packets">
        <NavigationHeader history={route.history} title="Installed Packets" />
        <InstalledPackets />
      </Route>
    </Switch>
  </div>
)

const App = () => {
  const [packets, setPackets] = useState([])
  const [activePacket, setActivePacket] = useState(null)

  useEffect(() => {
    getTouchbarPackets().then(setPackets)

    const popupListener = (message /* sender, sendResponse */) => {
      if (message.type === 'active_packet_changed') {
        setActivePacket(message.payload)
      }
    }

    addPopupMessageListener(popupListener)

    return () => {
      removePopupMessageListener(popupListener)
    }
  }, [])

  return (
    <PopupContext.Provider value={{ touchbarPackets: packets }}>
      <Router initialEntries={['/']}>
        <GlobalStyles />
        <Switch>
          <Route path="/" exact component={MainMenu} />
          <Route component={SubRoutes} />
        </Switch>
      </Router>
    </PopupContext.Provider>
  )
}

const appElement = document.querySelector('#app')
ReactDOM.render(<App />, appElement)
