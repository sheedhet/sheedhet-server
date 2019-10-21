import React, { useState } from 'react'
import Player from 'player'
import Pile from 'pile'
import ControllablePlayer from 'controllable_player'
import Sheedhet from 'sheedhet'
import 'babel-polyfill'
import useGameState from 'game_state'
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

  const submitPlayHandler = (event) => {
    // console.log('submitting form?', event)
    event.preventDefault()
    const form_data = new FormData(event.target)
    const pile_names = Array.from(form_data.keys())
    const destination = event.target['destination'].value
    const hand = pile_names.reduce((piles, name) => {
      piles[name] = form_data.getAll(name)
      return piles
    }, {})
    const play = {
      'hand': hand,
      'destination': destination,
      'position': position
    }
    // console.log('attempting play', play)
    sheedhet.attemptPlay(play).then((new_state) => {
      if (new_state) {
        // console.log('here comes the new state:', new_state)
        setGameState(new_state)
      } else {
        // console.log('no new state returned', new_state)
        // nothing really?
      }
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
