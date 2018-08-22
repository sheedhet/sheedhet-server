import React from 'react'

export default function Card(props) {
  const suit_lookup = {
    'd': 'diamonds',
    'h': 'hearts',
    's': 'spades',
    'c': 'clubs',
  }
  const suit = suit_lookup[props.card_string.slice(-1)]
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
  const rank = rank_lookup[props.card_string.slice(0, -1)]
  const face_up = props.card_string == 'xx' ? 'back' : 'face'
  const random_angle = (min, max) => {
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min)) + min //The maximum is exclusive and the minimum is inclusive
  }
  const random_skew_angle = () => {
    return random_angle(-30.0, 30.0) / 15.0
  }
  const card_style = {
    transform: 'rotate(' + random_skew_angle() + 'deg)'
  }
  const css_classes = ['card', suit, rank, props.play_css_classes].join(' ')
  // const in_plays = () => {
  //   if (props.in_plays.length) {
  //     const x = props.in_plays.map((y) => 'play' + y ).join(' ')
  //     return x
  //   } else {
  //     return ''
  //   }
  // }
  // const highlight_plays = (playClass) => {
  //   for (let card of cardsInPlay(playClass)) {
  //     card.classList.add('highlight-' + playClass)
  //   }
  // }
  // const unhighlight_plays = (playClass) => {
  //   for (let card of cardsInPlay(playClass)) {
  //     card.classList.remove('highlight-' + playClass)
  //   }
  // }
  // const cardsInPlay = (playClass) => document.querySelectorAll('.card.' + playClass)
  // CARDS SHOULD BE OPTIONALLY BE RENDERED AS CHECKBOXES WHEN
  // THEY'RE PLAYABLE AND MAYBE NOT WHEN NOT?
  // ALTERNATIVELY CAPTURE NON-PLAY CLICKS AND DISALLOW
  // CHECKBOX FROM BEING CLICKED??
  // NO, WE JUST DISABLE THEM IF THEY"RE NOT PART OF A PLAY!
  if (props.plays && props.plays.length) {
    return (
      <div
        className={css_classes}
        style={card_style}
        data-index={props.index}
        data-string={props.card_string}
      // onMouseEnter={highlight_plays(in_plays())}
      // onMouseLeave={unhighlight_plays(in_plays())}
      >
        <div className={face_up}></div>
        <input type="checkbox"></input>
      </div>
    )
  } else {
    return (
      <div
        className={css_classes}
        style={card_style}
        data-index={props.index}
        data-string={props.card_string}
      >
        <div className={face_up}></div>
      </div>
    )
  }
}
