import React from 'react'
import Pile from 'pile'

export default function Hand(props) {
  const cardMouseEnterHandler = (event) => {
    const card_string = event.target.dataset['string']
    // const plays = event.target.
  }
  const cardMouseLeaveHandler = (event) => {
    const card_string = event.target.dataset['string']
  }
  return (
    <div className="hand">
      {['in_hand', 'face_up', 'face_down'].map( pile_name =>
        <Pile
          contents={props.cards[pile_name]}
          pile_name={pile_name}
          key={pile_name}
          plays={
            props.plays.reduce( (result, play) => {
              if (play.hand[pile_name]) {
                return result.push(play.hand[pile_name])
              } else {
                return result
              }
            }, [])
          }
        />
      )}
    </div>
  );
}
