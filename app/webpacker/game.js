import React from 'react'
import Player from 'player'
import Pile from 'pile'
import Sheedhet from 'sheedhet'

export default class Game extends React.Component {
  constructor () {
    super()
    let container = document.getElementById('sheedhet_container')
    let state_json = container.dataset['game']
    let state = JSON.parse(state_json)
    this.state = state
    this.position = container.dataset['position']
    this.id = container.dataset['game_id']
    this.sheedhet = new Sheedhet(this.id, this.position, 'http://0.0.0.0:3000')
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

  submit_play_handler (_event) {
    _event.preventDefault()
    let selected = _event.target.querySelectorAll(':checked')
    let result = {}
    let play_json = selected.forEach( selector => {
      let [hand_name, card_string] = selector.id.split('-')
      if (Array.isArray(result[hand_name])) {
        result[hand_name].push(card_string)
      } else {
        result[hand_name] = [card_string]
      }
    })
  }

  render () {
    return (
      <form className="game" onSubmit={this.submit_play_handler}>

        <div className="opponents">
          {this.opponents().map( (player) =>
            <Player
              player={player}
              plays={
                this.state.valid_plays.filter(play =>
                  play.position == player.position
                )
              }
              key={player.position}
            />
          )}
        </div>
          <div className="community">
            <Pile
              pileName="play"
              contents={this.state.play_pile}
            />
            <Pile
              pileName="draw"
              contents={this.state.draw_pile}
            />
            <Pile
              pileName="discard"
              contents={this.state.discard_pile}
            />
          </div>
          <div className="self">
            <Player
              player={this.self()}
              plays={
                this.state.valid_plays.filter(play => {
                  const x = play.position == this.self().position
                  return x
                })
              }
            />
          </div>
      </form>
    );
  }
}
