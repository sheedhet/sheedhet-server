import React, { useState, useEffect } from 'react'
import Pile from './pile'

const CollapsiblePile = (props) => {
  const [visible_offset, setVisibleOffset] = useState(0)
  const left_pile = props.contents.slice(0, visible_offset)
  const focus_end_index = visible_offset + props.hand_size
  const focus_pile = props.contents.slice(visible_offset, focus_end_index)
  const right_pile = props.contents.slice(focus_end_index)
  const props_object = {
    'pile_name': props.pile_name,
    'cardOnClick': props.cardOnClick,
    'playable_card_keys': props.playable_card_keys,
    'selected_cards': props.selected_cards,
  }
  const style_object = {
  //   // ':nth-child(-n+3)': `translateX(${calculate_spacing_here!!})`
  }

  return (
    <span className={`collapsible pile ${props.pile_name}`}>
      <span
        className={`collapsible_pile_container`}
        style={style_object}
      >
        <Pile
          {...props_object}
          contents={props.contents}
          key={props.contents.join()}
        />
      </span>
    </span>
  )
}

export default CollapsiblePile
