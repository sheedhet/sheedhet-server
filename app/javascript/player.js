import React from 'react'
import Hand from 'hand'


export default function Player(props) {
  let has_plays = props.plays.length > 0 ? " has_plays" : ""
  return (
    <div className={"player position" + props.player.position + has_plays}>
      <span className='player_name'>{props.player.name}</span>
        <Hand
          cards={props.player.cards}
          plays={props.plays}
        />
    </div>
  );
}
