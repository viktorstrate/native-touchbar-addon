import React from 'react'
const NavigationHeader = ({ history }) => {
  return (
    <div>
      <a href="#" onClick={() => history.goBack()}>
        Back
      </a>
    </div>
  )
}

export default NavigationHeader
