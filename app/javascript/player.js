import React from 'react'
import Hand from 'hand'


export default function Player(props) {
  return (
    <div className={"player position" + props.player.position}>
      <span className='player_name'>{props.player.name}</span>
        <Hand
          cards={props.player.cards}
        />
    </div>
  );
}
