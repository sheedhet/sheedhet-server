import React from 'react'

export default function Card(props) {
  const suit_lookup = {
    'd': 'diamonds',
    'h': 'hearts',
    's': 'spades',
    'c': 'clubs',
  }

  const rank_lookup = {
    'a': 'rank1',
    '2': 'rank2',
    '3': 'rank3',
    '4': 'rank4',
    '5': 'rank5',
    '6': 'rank6',
    '7': 'rank7',
    '8': 'rank8',
    '9': 'rank9',
    '10': 'rank10',
    'j': 'rank11',
    'q': 'rank12',
    'k': 'rank13',
  }

  const random_angle = (min, max) => {
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min)) + min //The maximum is exclusive and the minimum is inclusive
  }

  const random_skew_angle = () => {
    return random_angle(-30.0, 30.0) / 15.0
  }

  const card_style = {
    transform: 'rotate(' + random_skew_angle() + ' deg)'
  }

  const suit = suit_lookup[props.cardString.slice(-1)]
  const rank = rank_lookup[props.cardString.slice(0, -1)]
  const face_up = props.cardString == 'xx' ? 'back' : 'face'
  const css_classes = ['card', suit, rank, props.playCssClasses].join(' ')
  const has_plays = (props.playCssClasses.match(/\bplay\w+/) || []).length
  const input_id = `${props.cardString}-${props.index}`

  return (
    <div
      style={card_style}
      data-index={props.index}
      data-string={props.cardString}
    >
      <input
        className="card-selector"
        type="checkbox"
        disabled={has_plays ? '' : ' disabled'}
        id={input_id}
      />
      <label
        className={css_classes}
        htmlFor={input_id}
        onMouseOver={props.mouseOverCardHandler}
        onMouseOut={props.mouseOutCardHandler}
      >
        <div className={face_up}></div>
      </label>
    </div>
  )
}
