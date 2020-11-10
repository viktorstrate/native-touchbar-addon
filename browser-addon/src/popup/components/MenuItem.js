import React from 'react'
import { Link } from 'react-router-dom'
import styled from 'styled-components'

const ItemWrapper = styled.div`
  padding: 4px 8px;
  margin: 2px 0;

  &:hover {
    background-color: #eee;
  }
`

const MenuItem = ({ label, navigateTo }) => {
  const item = <ItemWrapper>{label}</ItemWrapper>

  if (navigateTo) {
    return <Link to={navigateTo}>{item}</Link>
  }

  return item
}

export default MenuItem
