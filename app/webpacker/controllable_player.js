import React from 'react'
import Play from './play'
import Pile from './pile'

class ControllablePlayer extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      player: props.player,
      plays: props.plays,
      selected_cards: props,
    }
    this.cardInputOnChangeHandler = this.cardInputOnChangeHandler.bind(this)
  }

  generate_card_keys(hand) {
    return Object.keys(hand).reduce((cards, pile_name) => {
      const pile = hand[pile_name]
      pile.forEach((card, index) => {
        const card_key = `${pile_name}-${index}-${card}`
        cards.push(card_key)
      })
      return cards
    }, [])
  }

  cardInputOnChangeHandler(event) {
    const checked = event.target.checked
    const card_id = event.target.id

    checked ? selected_cards_set.add(card_id) : selected_cards_set.delete(card_id)
    const selected_cards = [...selected_cards_set]
    const selectable_plays = this.selectable_plays(selected_cards)

    this.setState({
      selected_cards: selected_cards,
    })
  }

  render() {
    return (
      <div className='controllable player'>
        <span className='player_name'>{this.state.player.name}</span>
        <div className="hand">
          {['in_hand', 'face_up', 'face_down'].map((pile_name) =>
            <Pile
              contents={this.state.player.cards[pile_name]}
              pile_name={pile_name}
              key={pile_name}
            />
          )}
        </div>
        <div className='plays'>
          {this.state.plays.map((play, i) => {
            return (
              <Play
                key={i}
                play={play}
              />
            )
          })}
        </div>
      </div>
    )
  }
}

export default ControllablePlayer
