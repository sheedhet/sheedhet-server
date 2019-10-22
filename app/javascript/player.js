import React from 'react'
import Pile from 'pile'

const Player = (props) => {
  // console.log(`Player.render(${props.player.name})`, props.player)
  return (
    <div className='player'>
      <a href={props.uri}>
        <span className='player_name'>{props.player.name}</span>
      </a>
      <div className="hand">
        {['in_hand', 'face_down', 'face_up'].map((pile_name) =>
          <Pile
            contents={props.player.cards[pile_name]}
            pile_name={pile_name}
            key={pile_name}
            inputs={(props.inputs && props.inputs[pile_name]) || false}
          />
        )}
      </div>
    </div>
  );
}

export default Player
