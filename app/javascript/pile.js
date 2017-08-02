import React from 'react'
import Card from 'card'

export default function Pile(props) {
  return (
    <div className='pile' data-type={props.pile_name}>
      {props.contents.map( (card_string, i) =>
        <Card
          card_string={card_string}
          key={i}
        />
      )}
    </div>
  );
}
