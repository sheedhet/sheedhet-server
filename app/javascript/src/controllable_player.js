// import React from 'react'
import React, { useState, useEffect } from 'react'
import Play from './play'
import Pile from './pile'
import CollapsiblePile from './collapsible_pile'

const ControllablePlayer = (props) => {
  const name = props.player.name
  const cards = props.player.cards
  const plays = props.plays
  const [selectable_plays, setSelectablePlays] = useState(plays)
  const [selected_cards, setSelectedCards] = useState([])
  const hand_size = props.hand_size

  // console.log('Render controllable player: ', name)
  // console.log('cards: ', cards)
  // console.log('selected cards: ', selected_cards)
  // console.log('plays: ', plays)

  const hand_card_keys = (hand) => {
    return Object.entries(hand).reduce( (card_keys, [pile_name, pile]) => {
      let unmatched_cards = [...pile]
      cards[pile_name].forEach( (card, index) => {
        if (unmatched_cards.includes(card)) {
          card_keys.push(`${pile_name}-${index}-${card}`)
          unmatched_cards.splice(unmatched_cards.indexOf(card), 1)
        }
      })
      const x = card_keys
      // console.log('play_card_keys: return=', x)
      return x
    }, [])
  }

  const play_card_keys = (play) => {
    if (play.destination.startsWith('flip')) {
      const card_index = play.destination.slice(-1)
      return [`face_down-${card_index}-xx`]
    } else if (play.destination == 'in_hand') {
      // do nothing yet? we need to put inputs on pickup pile
      return []
    } else {
      return hand_card_keys(play.hand)
    }
  }

  const find_playable_card_keys = (playable_plays) => {
    // console.log('find_playable_card_keys: playable_plays=', playable_plays)
    const x = playable_plays.reduce( (card_keys_in_plays, play) => {
      play_card_keys(play).forEach((card_key) => {
        if (!card_keys_in_plays.includes(card_key)) {
          card_keys_in_plays.push(card_key)
        }
      })
      return card_keys_in_plays
    }, [])
    // console.log('find_playable_card_keys: return=', x)
    return x
  }

  const initial_playable_card_keys = find_playable_card_keys(plays)
  // console.log('initial playable card keys: ', initial_playable_card_keys)
  const [playable_card_keys, setPlayableCardKeys] = useState(initial_playable_card_keys)

  useEffect( () => {
    const find_new_selectable_plays = () => {
      if (selected_cards.length > 0) {
        return plays.filter((play) => {
          const card_keys_in_play = play_card_keys(play)
          return selected_cards.every((card_key) => {
            return card_keys_in_play.includes(card_key)
          })
        })
      } else {
        return plays
      }
    }
    const new_selectable_plays = find_new_selectable_plays()
    setSelectablePlays(new_selectable_plays)
    setPlayableCardKeys(find_playable_card_keys(new_selectable_plays))
  }, [selected_cards, plays, setSelectablePlays])

  const cardClickHandler = (event) => {
    const checked = event.target.checked
    const key = event.target.id
    if (checked) {
      setSelectedCards([...selected_cards, key])
    } else {
      setSelectedCards(selected_cards.filter((card) => card != key))
    }
  }

  // console.log('selecteable_plays: ', selectable_plays)
  // selectable_plays
  // console.log('selected cards: ', selected_cards)

  // console.log('playable_card_keys!!!: ', playable_card_keys)
  // playable_card_keys

  return (
    <div className='controllable player'>
      <span className='player_name'>{name}</span>
      <div className="hand">
        {Object.keys(cards).map((pile_name) => {
          const props_object = {
            'contents': cards[pile_name],
            'pile_name': pile_name,
            'key': pile_name + cards[pile_name].join(),
            'cardOnClick': cardClickHandler,
            'playable_card_keys': playable_card_keys,
            'selected_cards': selected_cards
          }
          return (<Pile {...props_object} />)
        })}
      </div>
      <div className='plays'>
        {selectable_plays.map((play, i) => {
          return (
            <Play
              key={i}
              play={play}
              click_handler={() => setSelectedCards([])}
            />
          )
        })}
      </div>
    </div>
  )
}

export default ControllablePlayer
