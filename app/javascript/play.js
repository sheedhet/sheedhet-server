import React from 'react'

const Play = (props) => {
  const click_handler = (event) => {
    event.target.name = 'destination'
    event.target.value = props.play.destination
  }

  let label = ''
  switch (props.play.destination) {
    case 'in_hand':
      label = 'Pick Up'
      break;
    case 'play_pile':
      label = 'Play'
      break;
    case 'swap':
      label = 'Swap'
      break;
    default:
      if (props.play.destination.startsWith('flip')) {
        label = 'Flip'
      }
  }

  return(
    <button
      className={`play`}
      data-destination={props.play.destination}
      type="submit"
      onClick={click_handler}
    >{label}</button>
    )
  }

  export default Play
