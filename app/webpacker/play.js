import React from 'react'

export default function Play(props) {
  const cardsInPlay = () => document.querySelectorAll('.play' + props.index)
  const highlightCards = () => {
    for (let card of cardsInPlay()) {
      card.classList.add('highlight')
    }
  }
  const unhighlightCards = () => {
    for (let card of cardsInPlay()) {
      card.classList.remove('highlight')
    }
  }

  if (Object.keys(props.hand).length == 0) {
      return null
  } else {
    return (
        <div
          className="play"
          data-position={props.position}
          data-in-hand={props.hand.in_hand}
          data-face-up={props.hand.face_up}
          data-face-down={props.hand.face_down}
          onMouseEnter={highlightCards}
          onMouseLeave={unhighlightCards}
          onClick={() => props.clickCallback(props.hand)}
        >Play {props.index}</div>
    );
  }
}
