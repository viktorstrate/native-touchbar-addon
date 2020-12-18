import React from 'react'
import styled from 'styled-components'

import iconBack from '../assets/icon-back.svg'

const Navbar = styled.nav`
  padding: 4px;
  height: 40px;
  border-bottom: 1px solid #dfdfe0;
  display: flex;
  align-items: center;
`

const BackLink = styled.a`
  padding: 8px;
  margin-right: 8px;
  width: 32px;
  height: 32px;
  position: absolute;

  &:hover {
    background-color: #eee;
  }
`

const Title = styled.h1`
  margin: 0;
  padding: 0;
  font-weight: bold;
  font-size: 1rem;
  text-align: center;
  width: 100%;
`

const NavigationHeader = ({ history, title }) => {
  return (
    <Navbar>
      <BackLink href="#" onClick={() => history.goBack()} aria-label="Back">
        <img src={iconBack} />
      </BackLink>
      <Title>{title}</Title>
    </Navbar>
  )
}

export default NavigationHeader
