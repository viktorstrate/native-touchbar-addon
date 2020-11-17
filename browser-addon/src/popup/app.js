import React from 'react'
import ReactDOM from 'react-dom'
import { createGlobalStyle } from 'styled-components'
import { MemoryRouter as Router, Route } from 'react-router-dom'
import MainMenu from './routes/MainMenu'
import NavigationHeader from './components/NavigationHeader'

const GlobalStyles = createGlobalStyle`
  body {
    margin: 0;
    padding: 0;

    width: 100%;
    min-width: 360px;
  }
`

browser.runtime
  .sendMessage({
    scope: 'popup_message',
    type: 'get_touchbar_packets',
  })
  .then(packets => {
    console.log('popup touchbar packets', packets)
  })

const App = () => (
  <Router initialEntries={['/']}>
    <GlobalStyles />
    <Route path="/(.+)" component={NavigationHeader} />
    <Route path="/" exact>
      <MainMenu />
    </Route>
  </Router>
)

const appElement = document.querySelector('#app')
ReactDOM.render(<App />, appElement)
