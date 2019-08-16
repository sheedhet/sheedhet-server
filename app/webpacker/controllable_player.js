import React from 'react'
import Play from './play'
import Pile from './pile'

class ControllablePlayer extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      name: props.player.name,
      cards: props.player.cards,
      plays: props.plays,
      selected_cards: [],
    }
    this.cardClickHandler = this.cardClickHandler.bind(this)
  }

  static getDerivedStateFromProps(props, state) {
    // wish we didn't have to bust the cache on this state...
    console.log('updating: ', props, state)
    let entries = Object.entries(props)
    let new_state = {}
    for (const [property, value] of entries) {
      new_state[property] = value
    }
    let hand_card_keys = ControllablePlayer.hand_card_keys(new_state.player.cards, new_state.player.cards)
    let new_selected_cards = state.selected_cards.filter((card_key) => {
      return hand_card_keys.includes(card_key)
    })
    new_state.selected_cards = new_selected_cards
    console.log('did we get here?')

    return new_state
  }

  // shouldComponentUpdate(next_props, next_state) {
    // console.log('are WE updating?')
    // console.log('props', next_props)
    // console.log('state:', next_state)
    // return true
  // }

  static hand_card_keys(hand, state) {
    console.log('this stupid hand', hand, state)
    return Object.keys(hand).reduce((cards, pile_name) => {
      // gross! we kept mutating the state somehow thus an empty map
      const pile = hand[pile_name].map(card => card)
      let player_pile = state[pile_name]
      console.log('whats up with player pile?', player_pile)
      player_pile.forEach((card, index) => {
        console.log('in this loop', card, index)
        if (pile.includes(card)) {
          console.log('create a new card', card, index)
          const card_key = `${pile_name}-${index}-${card}`
          cards.push(card_key)
          pile.splice(pile.indexOf(card), 1)
        }
      })
      return cards
    }, [])
  }

  play_card_keys(play) {
    if (play.destination.startsWith('flip')) {
      const card_index = play.destination.slice(-1)
      let x = [`face_down-${card_index}-xx`]
      return x
    } else if(play.destination == 'in_hand') {
      // do nothing yet? we need to put inputs on pickup pile
      return []
    } else {
      let x = this.constructor.hand_card_keys(play.hand, this.state.player.cards)
      return x
    }
  }

  selectable_plays() {
    console.log('find selectable plays')
    if (this.state.selected_cards.length > 0){
      console.log('there are selected cards...', this.state.selected_cards)
      const selectable_plays = this.state.plays.filter((play) => {
        const play_card_keys = this.play_card_keys(play)
        return this.state.selected_cards.every((card_key) => {
          return play_card_keys.includes(card_key)
        })
      })
      console.log('returning:', selectable_plays)
      return selectable_plays
    } else {
      console.log('no selected cards, all plays:', this.state.plays)
      return this.state.plays
    }
  }

  playable_card_keys(selectable_plays) {
    let x = selectable_plays.reduce( (card_keys_in_plays, play, i) => {
      let play_card_keys = this.play_card_keys(play)
      play_card_keys.forEach((card_key) => {
        if (!card_keys_in_plays.includes(card_key)) {
          card_keys_in_plays.push(card_key)
        }
      })
      return card_keys_in_plays
    }, [])
    console.log('dafuq wrong here', x)
    return x
  }

  cardClickHandler(event) {
    console.log('this still work?')
    const checked = event.target.checked
    const key = event.target.id
    let selected_cards = this.state.selected_cards
    if (checked) {
      selected_cards.push(key)
    } else {
      selected_cards.splice(selected_cards.indexOf(key), 1)
    }
    console.log('new selected:', selected_cards)
    this.setState({
      selected_cards: selected_cards,
      selectable_plays: this.selectable_plays()
    })
  }

  render() {
    console.log(`ControllablePlayer.render(${this.state.player.name}):` ,this.state.player, this.state.plays)
    const selectable_plays = this.selectable_plays()
    const playable_card_keys = this.playable_card_keys(selectable_plays)
    return (
      <div className='controllable player'>
        <span className='player_name'>{this.state.player.name}</span>
        <div className="hand">
          {Object.keys(this.state.player.cards).map((pile_name) =>
            <Pile
              contents={this.state.player.cards[pile_name]}
              pile_name={pile_name}
              key={this.state.player.cards[pile_name].join()}
              cardOnClick={this.cardClickHandler}
              playable_card_keys={playable_card_keys}
              selected_cards={this.state.selected_cards}
            />
          )}
        </div>
        <div className='plays'>
          {selectable_plays.map((play, i) => {
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
