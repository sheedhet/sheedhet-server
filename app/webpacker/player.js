import React from 'react'
import Pile from 'pile'

const Player = (props) => {
  const uri = () => {
    const game_elm = document.querySelector('#sheedhet_container')
    const game_id = game_elm.dataset['game_id']
    return `/games/${game_id}/players/${props.player.position}`
  }
  return (
    <div className='player position'>
      <a href={uri()}>
        <span className='player_name'>{props.player.name}</span>
      </a>
      <div className="hand">
        {['in_hand', 'face_up', 'face_down'].map((pile_name) =>
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
