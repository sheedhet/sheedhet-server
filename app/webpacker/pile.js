import React from 'react'
import Card from 'card'

export default function Pile(props) {
  console.log(`new Pile, given ${props.plays ? props.plays.length : '0'} plays`)
  const play_css_classes = (card_string) => {
    if (props.plays && props.plays.length) {
      return props.plays.reduce( (result, play, i) => {
        if (play.includes(card_string)) {
          result.push(`play${i}`)
        }
        return result
      }, []).join(' ')
    } else {
      return false
    }
  }
  // const on_click_for = (card_string) => {
  //   if (props.plays && props.plays.includes(card_string)) {
  //     return props.onClick
  //   } else {
  //     return null
  //   }
  // }
  return (
    <div className={'pile ' + props.pile_name}>
      {props.contents.map( (card_string, i) =>
        <Card
          card_string={card_string}
          index={i}
          key={i}
          // pile_size={props.contents.length}
          play_css_classes={play_css_classes(card_string)}
          // onClick={on_click_for(card_string)}
        />
      )}
    </div>
  );
}
