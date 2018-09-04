import React from 'react'
import Card from 'card'

const Pile = (props) => {
  const play_css_classes = (card_string) => {
    if (props.plays && props.plays.length) {
      return props.plays.reduce( (result, play, i) => {
        if (play.includes(card_string)) {
          result.push(`play${i}`)
        }
        return result
      }, []).join(' ')
    } else {
      return ''
    }
  }

  const mouse_over = (card_string) => {
    if (props.mouseOverCardHandler) {
      props.mouseOverCardHandler(play_css_classes(card_string))
    }
  }

  const mouse_out = (card_string) => {
    if (props.mouseOutCardHandler) {
      props.mouseOutCardHandler(play_css_classes(card_string))
    }
  }

  return (
    <div className={'pile ' + props.pileName}>
      {props.contents.map( (card_string, i) =>
        <Card
          cardString={card_string}
          index={i}
          key={i}
          playCssClasses={play_css_classes(card_string)}
          mouseOverCardHandler={() => mouse_over(card_string)}
          mouseOutCardHandler={() => mouse_out(card_string)}
        />
      )}
    </div>
  );
}

export default Pile
