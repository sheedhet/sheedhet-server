import React from 'react'

const Card = (props) => {
  const suit_lookup = (suit_string) => {
    return {
      'd': 'diamonds',
      'h': 'hearts',
      's': 'spades',
      'c': 'clubs',
    }[suit_string]
  }

  const rank_lookup = (rank_string) => {
    return {
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
    }[rank_string]
  }

  const suit = suit_lookup(props.cardString.slice(-1))
  const rank = rank_lookup(props.cardString.slice(0, -1))
  const face_up = props.cardString == 'xx' ? 'back' : 'face'
  const collapsed = props.collapsed ? 'collapsed' : ''
  const css_classes = ['card', suit, rank, collapsed].join(' ')
  const card_style = { transform: `rotate(${props.skew_angle}deg)` }
  return(
    <label
      className={css_classes}
      style={card_style}
      data-string={props.cardString}
      data-index={props.index}
      htmlFor={props.index}
    >
      <div className={face_up}></div>
    </label>
  )
}

export default Card
