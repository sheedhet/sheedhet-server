import React, { useState } from 'react'
import Player from 'player'
import Pile from 'pile'
import ControllablePlayer from 'controllable_player'
import Sheedhet from 'sheedhet'
import 'babel-polyfill' // Enables async/await for babel
import useGameState from 'game_state'
import useInterval from 'use_interval'
import PlayAnimator from 'play_animator'
// console.log('React version:', React.version)

const Game = (props) => {
  const container = document.getElementById('sheedhet_container')
  const state_json = container.dataset['game']
  const id = container.dataset['game_id']
  const position = container.dataset['position']

  const [game_state, setGameState] = useGameState(JSON.parse(state_json))
  // console.log('game_state:', game_state)
  const sheedhet = new Sheedhet(id, position, window.location.origin)
  // const sheedhet = new Sheedhet(id, position, 'http://0.0.0.0:3000')

  const opponents = game_state.players.filter(
    player => player.position != position
  )

  const smartSetGameState = (new_state) => {
    delete new_state.id
    if (JSON.stringify(new_state) === JSON.stringify(game_state)) {
    } else {
      // console.log('here comes the new state:', new_state)
      // Heres our opportunity to animate the changes
      const new_history = new_state.history.slice(game_state.history.length)
      const animation_promises = new_history.map( (play) => {
        console.log(`Player ${play.play.position} did a ${play.play.destination} play`)
        return PlayAnimator(play.play)
      })
      console.log(`Resolve all ${animation_promises.length} animations`)
      Promise.all(animation_promises).then( (_results) => {
        console.log('all animations completed!')
        setGameState(new_state)
      })
    }
  }

  const [update_delay, setUpdateDelay] = useState(1000)
  const [num_update_failures, setNumUpdateFailures] = useState(0)

  useInterval(() => {
    sheedhet.updateState().then(
      (new_state) => {
        if (new_state) {
          smartSetGameState(new_state)
        } else {
          console.log('heres the safe place')
          // console.log('no new state returned')
          // nothing really?
        }
        if (update_delay != 1000) {
          // reset update_delay upon success in case it was backed off
          setUpdateDelay(1000)
          setNumUpdateFailures(0)
        }
      }, (_rejected_reason) => {
        // couldn't contact server, exponentially increase update_delay
        if (num_update_failures < 6) {
          setNumUpdateFailures(num_update_failures + 1)
        }
        const random_skew = Math.floor(Math.random() * 1000)
        const exponential_backoff = (2 ** num_update_failures) * 1000
        const new_delay = exponential_backoff + random_skew
        setUpdateDelay(new_delay)
      }
    )
  }, update_delay)

  const submitPlayHandler = (event) => {
    // slow down updates while we submit this
    setUpdateDelay(90000)
    event.preventDefault()
    // console.log('submitting form?', event)
    const form_data = new FormData(event.target)
    const pile_names = Array.from(form_data.keys())
    const destination = event.target['destination'].value
    const hand = pile_names.reduce((piles, name) => {
      if (name != 'destination') {
        piles[name] = form_data.getAll(name)
      }
      return piles
    }, {})
    const play = {
      'hand': hand,
      'destination': destination,
      'position': position
    }
    console.log('attempting play', play)
    sheedhet.attemptPlay(play).then((new_state) => {
      if (new_state) {
        // console.log('here comes the new state:', new_state)
        smartSetGameState(new_state)

      } else {
        // console.log('no new state returned', new_state)
        // nothing really?
      }
      setUpdateDelay(1000)
    })
  }

  // console.log('valid plays::: ',game_state.valid_plays)
  return (
    <form
      className="game"
      onSubmit={submitPlayHandler}
      id="play_form"
    >
      <div className="opponents">
        {opponents.map( (player) => {
          return(
            <Player
              player={player}
              plays={
                game_state.valid_plays.filter(play =>
                  play.position == player.position
                )
              }
              uri={`/games/${id}/players/${player.position}`}
              key={player.position}
            />
          )
        })}
      </div>
        <div className="community">
          <Pile
            pile_name="play"
            contents={game_state.play_pile}
          />
          <Pile
            pile_name="draw"
            contents={game_state.draw_pile}
          />
          <Pile
            pile_name="discard"
            contents={game_state.discard_pile}
          />
        </div>
        <div className="self">
          <ControllablePlayer
            player={
              game_state.players.find( (player) => {
                return player.position == position
              })
            }
            plays={
              game_state.valid_plays.filter( (play) => {
                return play.position == position
              })
            }
            hand_size={game_state.hand_size}
          />
        </div>
    </form>
  )
}

export default Game
