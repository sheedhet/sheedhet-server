import React from 'react'
import Pile from 'pile'

export default function Hand(props) {
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
                return result.concat(play.hand[pile_name])
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
