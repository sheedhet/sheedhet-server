import React from 'react'
import Pile from 'pile'

const Hand = (props) => {
  const hand_ref = React.createRef()
  const highlight_plays = (plays) => {
    if (plays && hand_ref) {
      let plays_array = plays.split(' ')
      hand_ref.current.classList.add(...plays_array)
    }
  }
  const unhighlight_plays = (plays) => {
    if (plays && hand_ref) {
      let plays_array = plays.split(' ')
      hand_ref.current.classList.remove(...plays_array)
    }
  }
  const plays_for_pile = (pile_name) => {
    return props.plays.reduce((result, play) => {
      if (play.hand[pile_name]) {
        result.push(play.hand[pile_name])
      }
      return result
    }, [])
  }
  return (
    <div className="hand" ref={hand_ref}>
      {['in_hand', 'face_up', 'face_down'].map( pile_name =>
        <Pile
          contents={props.cards[pile_name]}
          pileName={pile_name}
          key={pile_name}
          plays={plays_for_pile(pile_name)}
          mouseOverCardHandler={highlight_plays}
          mouseOutCardHandler={unhighlight_plays}
        />
      )}
    </div>
  );
}

export default Hand
