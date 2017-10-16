import React from 'react'
import Player from 'player'
import Pile from 'pile'

export default class Game extends React.Component {
  constructor () {
    super()
    let container = document.getElementById('sheedhet_container')
    let state_json = container.dataset['game']
    this.position = container.dataset['position']
    let state = JSON.parse(state_json)
    this.state = state
  }

  opponents () {
    if (this.position) {
      return this.state.players.filter( player =>
        player.position != this.position
      );
    } else {
      return this.state.players.slice(1);
    }
  }

  self () {
    if (this.position) {
      return this.state.players.find( player =>
        player.position == this.position
      );
    } else {
      return this.state.players[0];
    }
  }

  render () {
    return (
      <div className="game">
        <div className="opponents">
          {this.opponents().map( (player) =>
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
            player={this.self()}
          />
        </div>
      </div>
    );
  }
}
