import React from 'react'
import Card from 'card'

const Pile = (props) => {
  const contents = props.contents || []

  const rand = (seed) => {
    const rand = Math.sin(seed) * 10000;
    return rand - Math.floor(rand);
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

  return (
    <div className={'pile ' + props.pile_name} >
      {contents.map((card_string, i) => {
        const key = `${props.pile_name}-${i}-${card_string}`
        return(
          <Card
            cardString={card_string}
            pile_name={props.pile_name}
            key={key}
            index={key}
            skew_angle={random_skew_angle(card_string, i)}
          />
        )
      })}
    </div>
  )
}

export default Pile
