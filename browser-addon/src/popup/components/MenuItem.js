import React from 'react'
import Separator from './MenuSeparator'
import styled from 'styled-components'

const ItemWrapper = styled.div`
  padding: 4px;
  margin: 2px 0;

  &:hover {
    background-color: #eee;
  }
`

const MenuItem = ({ label }) => (
  <ItemWrapper>{ label }</ItemWrapper>
)

export default MenuItem
