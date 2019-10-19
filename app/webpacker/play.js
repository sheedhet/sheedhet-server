import React from 'react'

const Play = (props) => {
  const click_handler = (event) => {
    event.target.name = 'destination'
    event.target.value = props.play.destination
    props.click_handler()
  }
  return(
    <button
      className={`play`}
      type="submit"
      onClick={click_handler}
    >{props.play.destination}</button>
    )
  }

  export default Play
