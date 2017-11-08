import React from 'react'
import Card from 'card'

export default function Pile(props) {
  return (
    <div className={'pile ' + props.pile_name}>
      {props.contents.map( (card_string, i) =>
        <Card
          card_string={card_string}
          index={i}
          key={i}
          pile_size={props.contents.length}
          playable={props.plays.includes(card_string)}
        />
      )}
    </div>
  );
}
