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

  playClickHandler (position, hand) {
    console.log("play clicked: ", position, hand)
    let matching_valid_plays = this.state.valid_plays.filter((play) => {
      let a = JSON.stringify(play.hand)
      let b = JSON.stringify(hand)
      return play.position == position && a == b
    })
    if (matching_valid_plays.length > 0) {
      let ply = {'position': position, 'hand': hand}
      let plyson = JSON.stringify(ply)
      console.log('valid play', ply)
      let new_state = this.sheedhet.attemptPlay(ply)
      this.setState(new_state)
    } else {
      console.log('invalid play')
    }
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
            pile_name="play"
            contents={this.state.play_pile}
          />
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
            plays={
              this.state.valid_plays.filter(play =>
                play.position == this.self().position
              )
            }
            clickCallback={
              hand => this.playClickHandler(this.self().position, hand)
            }
          />
        </div>
      </div>
    );
  }
}
