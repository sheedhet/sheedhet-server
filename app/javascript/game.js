import React from 'react'
import Player from 'player'

export default class Game extends React.Component {
  constructor () {
    super()
    let state_json = document.getElementById('sheedhet_container').dataset['game']
    let state = JSON.parse(state_json)
    this.state = state
  }

  render () {
    return (
      <div className="game">
        {this.state.players.map( (player) =>
          <Player
            player={player}
            key={player.position}
          />
        )}
      </div>
    );
  }
}
