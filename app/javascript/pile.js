import React from 'react'
import Card from 'card'

export default function Pile(props) {
  const in_plays = (card_string) => {
    return props.plays.reduce( (result, play, i) => {
      if (play == card_string) {
        result.push(i)
      }
        return result
    }, [])
  }
  return (
    <div className={'pile ' + props.pile_name}>
      {props.contents.map( (card_string, i) =>
        <Card
          card_string={card_string}
          index={i}
          key={i}
          pile_size={props.contents.length}
          in_plays={in_plays(card_string)}
          onClick={props.plays.includes(card_string) ? props.onClick : null}
        />
      )}
    </div>
  );
}
