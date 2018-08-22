import React from 'react'
import Hand from 'hand'

export default function Player(props) {
  const has_plays = props.plays.length ? ' has_plays' : ''
  const css_classes = `player position${props.player.position}` + has_plays
  console.log(`new player with ${props.plays ? props.plays.length : '0'} plays`)
  return (
    <div className={css_classes}>
      <span className='player_name'>{props.player.name}</span>
        <Hand
          cards={props.player.cards}
          plays={props.plays}
        />
    </div>
  );
}
