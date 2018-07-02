import React from 'react'
import Card from 'card'

export default function Pile(props) {
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ! this in_plays stuff is broke, plus you need to finish  !
  // ! the transition to using destinations in the Play model !
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  const in_plays = (card_string) => {
    if (props.plays) {
      return props.plays.reduce( (result, play, i) => {
        if (play == card_string) {
          result.push(i)
        }
        return result
      }, [])
    } else {
      return false
    }
  }
  const on_click_for = (card_string) => {
    if (props.plays && props.plays.includes(card_string)) {
      return props.onClick
    } else {
      return null
    }
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
          onClick={on_click_for(card_string)}
        />
      )}
    </div>
  );
}
