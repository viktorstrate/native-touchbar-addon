import React from 'react'
import ReactDOM from 'react-dom'
import { createGlobalStyle } from 'styled-components'

import MenuItem from './components/MenuItem'
import MenuLabel from './components/MenuLabel'
import Separator from './components/MenuSeparator'

const GlobalStyles = createGlobalStyle`
  body {
    margin: 0;
    padding: 0;

    width: 100%;
    min-width: 360px;
  }
`

const App = () => (
  <div>
    <GlobalStyles />
    <MenuItem label="Load scripts" />
    <Separator />
    <MenuLabel>Some options</MenuLabel>
    <MenuItem label="Option A" />
    <MenuItem label="Option B" />
  </div>
)

const appElement = document.querySelector('#app')
ReactDOM.render(<App />, appElement)

