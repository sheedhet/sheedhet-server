import React from 'react'

const CardInput = (props) => {
  return (
    <input
      className="card-input"
      type="checkbox"
      id={props.id}
      onChange={props.onChangeHandler}
      // defaultChecked={props.checked}
    />
  )
}

export default CardInput
