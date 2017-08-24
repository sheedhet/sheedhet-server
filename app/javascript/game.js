import React from 'react'
import Player from 'player'
import Pile from 'pile'

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
        <div className="opponents">
          {this.state.players.slice(1).map( (player) =>
            <Player
              player={player}
              key={player.position}
            />
          )}
        </div>
        <div className="community">
          <Pile
            pile_name="draw"
            contents={this.state.draw_pile}
          />
          <Pile
            pile_name="discard"
            contents={this.state.discard_pile}
          />
        </div>
        <div className="self">
          <Player
            player={this.state.players[0]}
          />
        </div>
      </div>
    );
  }
}
