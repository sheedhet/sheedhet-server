import React from 'react'

const CardWithInput = (props) => {
  const [pile_name, _index, card_string] = props.id.split('-')
  return (
    <div>
      <input
        className="card-input"
        type="checkbox"
        id={props.id}
        name={pile_name}
        value={card_string}
        onChange={props.onChangeHandler}
        form="play_form"
        defaultChecked={props.checked}
      />
      {props.card}
    </div>
  )
}

export default CardWithInput
