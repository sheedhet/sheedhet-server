import React from 'react'

export default function Card(props) {
  const suit_lookup = {
    'd': 'diamonds',
    'h': 'hearts',
    's': 'spades',
    'c': 'clubs',
  }
  const suit = suit_lookup[props.card_string.slice(-1)];
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
  };
  const rank = rank_lookup[props.card_string.slice(0, -1)];
  const face_up = props.card_string == 'xx' ? 'back' : 'face';

  return (
    <div className={['card',suit,rank].join(' ')} onClick={null/*() => this.props.onClick() */}>
      <div className={face_up}></div>
    </div>
  );
}
