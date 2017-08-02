import React from 'react'
import Pile from 'pile'

export default function Hand(props) {
  return (
    <div className="hand">
      {['in_hand', 'face_up', 'face_down'].map( (pile_name) =>
        <Pile
          contents={props.cards[pile_name]}
          pile_name={pile_name}
          key={pile_name}
        />
      )}
    </div>
  );
}
