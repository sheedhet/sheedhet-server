import React from 'react'
import Play from './play'
import Pile from './pile'

class ControllablePlayer extends React.Component {
  constructor(props) {
    super(props)
    const cards = this.generate_card_keys(props.player.cards)
    const plays = props.plays.map( (play) => {
      play.cards = this.generate_card_keys(play.hand) // why the fuck were we doing this again?
        return play
      }
    )

    this.cardInputOnChangeHandler = this.cardInputOnChangeHandler.bind(this)
    const selectable_cards = Object.keys(this.find_card_plays(cards, plays))
    this.state = {
      player: props.player,
      plays: plays,
      cards: cards,
      selected_cards: [],
      selectable_plays: plays,
      selectable_cards: selectable_cards
    }
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

  find_card_plays(cards, plays) {
    return cards.reduce((cards_with_plays, card) => {
      const [pile_name, index, card_string] = card.split('-')
      plays.forEach((play, j) => {
        if (play.hand[pile_name] && play.hand[pile_name][index] === card_string) {
          if (card in cards_with_plays) {
            cards_with_plays[card].push(j)
          } else {
            cards_with_plays[card] = [j]
          }
        }
      })
      return cards_with_plays
    }, {})
  }

  selectable_plays(selected_cards) {
    const plays = this.state.plays
    if (selected_cards.length == 0) {
      return this.state.plays
    }
    const selected_cards_with_plays = this.find_card_plays(selected_cards, plays)
    const all_selected_play_indicies = Object.values(selected_cards_with_plays).reduce(
      (all_play_indicies, card_play_indicies) => {
        return all_play_indicies.concat(card_play_indicies)
      }, []
    )
    const all_selected_plays = all_selected_play_indicies.map( (i) => {
      return this.state.plays[i]
    })
    return all_selected_plays
  }

  cardInputOnChangeHandler(event) {
    const checked = event.target.checked
    const card_id = event.target.id
    let selected_cards_set = new Set(this.state.selected_cards_set)
    checked ? selected_cards_set.add(card_id) : selected_cards_set.delete(card_id)
    const selected_cards = [...selected_cards_set]
    const selectable_plays = this.selectable_plays(selected_cards)
    const selectable_cards_with_plays = this.find_card_plays(this.state.cards, selectable_plays)

    this.setState({
      selected_cards: selected_cards,
      selectable_plays: selectable_plays,
      selectable_cards: Object.keys(selectable_cards_with_plays)
    })
  }

  create_card_input(id, _checked) {
    return(
      <input
        className={`card_input`}
        type="checkbox"
        id={id}
        onChange={this.onChangeHandler}
        // defaultChecked={props.checked}
      />
    )
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
          {this.state.selectable_plays.map((play, i) => {
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
