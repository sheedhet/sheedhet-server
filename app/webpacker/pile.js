import React from 'react'
import Card from 'card'
import CardWithInput from 'card_with_input'

const Pile = (props) => {
  const contents = props.contents || []

  const rand = (seed) => {
    const rand = Math.sin(seed) * 10000
    return rand - Math.floor(rand)
  }

  const bounded_rand = (min, max, seed) => {
    const minimum = Math.ceil(min)
    const maximum = Math.floor(max)

    //The maximum is exclusive and the minimum is inclusive
    const random = Math.floor(rand(seed) * (maximum - minimum)) + minimum
    return random
  }

  const random_skew_angle = (card_string, index) => {
    const pile_name = props.pile_name
    const card_and_pile_name = `${card_string}${pile_name}`
    let string_codes = [...card_and_pile_name].map(
      (char) => { return char.charCodeAt(0) }
    )
    string_codes.unshift(index)
    const seed = parseInt(string_codes.join(''), 10)
    const angle = bounded_rand(-30.0, 30.0, seed) / 9.0
    return angle
  }

  const render_card = (key) => {
    const [_pile_name, i, card_string] = key.split('-')
    let collapsed = false
    const is_collapsed_left = i < props.visible_offset
    const is_collapsed_right = i > (props.visible_offset + props.visible_size)
    if (props.visible_offset && (is_collapsed_left || is_collapsed_right)) {
      collapsed = true
    }
    return(
      <Card
        cardString={card_string}
        key={key}
        index={key}
        skew_angle={random_skew_angle(card_string, i)}
        collapsed={collapsed}
      />
    )
  }

  return (
    <div className={`pile ${props.pile_name}`}>
      <div className={`pile_size_limiter`}>
        {contents.map((card_string, i) => {
          const key = `${props.pile_name}-${i}-${card_string}`
          const card = render_card(key)
          if (props.playable_card_keys && props.playable_card_keys.includes(key)) {
            return(
              <CardWithInput
                id={key}
                key={key}
                onChangeHandler={props.cardOnClick}
                card={card}
                defaultChecked={props.selected_cards.includes(key)}
              />
            )
          } else {
            return card
          }
        })}
      </div>
    </div>
  )
}

export default Pile
