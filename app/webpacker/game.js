import React from 'react'
import Player from 'player'
import Pile from 'pile'
import ControllablePlayer from 'controllable_player'
import Sheedhet from 'sheedhet'

export default class Game extends React.PureComponent {
  constructor() {
    super()
    let container = document.getElementById('sheedhet_container')
    let state_json = container.dataset['game']
    let state = JSON.parse(state_json)
    this.state = state
    this.position = container.dataset['position']
    this.id = container.dataset['game_id']
    this.sheedhet = new Sheedhet(this.id, this.position, 'http://0.0.0.0:3000')
    this.submitPlayHandler = this.submitPlayHandler.bind(this)
    this.passButtonHandler = this.passButtonHandler.bind(this)
  }

  pass_button_shit() {
    const pass_play = this.available_plays().filter((play) => {
      play.hand['play_pile'].length
    })
    return props.plays.reduce((result, play) => {
      if (play.hand[pile_name]) {
        result.push(play.hand[pile_name])
      }
      return result
    }, [])

  }

  opponents() {
    if (this.position) {
      return this.state.players.filter( player =>
        player.position != this.position
      )
    } else {
      return this.state.players.slice(1)
    }
  }

  self() {
    if (this.position) {
      return this.state.players.find( player =>
        player.position == this.position
      )
    } else {
      return this.state.players[0]
    }
  }

  available_plays() {
    return this.state.valid_plays.filter( (play) => {
      return play.position == this.position
    })
  }

  submitPlayHandler(_event) {
    _event.preventDefault()
    let selected = _event.target.querySelectorAll(':checked')
    let possible_play_names = selected[0].dataset['plays'].split(' ')
    let result = Array.from(selected).reduce((sult, selector) => {
      let [hand_name, card_string, _card_index] = selector.id.split('-')
      let plays = selector.dataset['plays'].split(' ')
      possible_play_names = [...new Set(plays)].filter((x) => new Set(possible_play_names).has(x))
      // NEED TO FILTER PLAYS HERE, IF THEYRE IN THE RESULT
      // THEN ONLY LET THEM REMAIN IF THE SELECTOR HAS THEM
      // IN THE PLAYS LIST!?!
      // do we??
      if (Array.isArray(sult[hand_name])) {
        sult[hand_name].push(card_string)
      } else {
        sult[hand_name] = [card_string]
      }
      return sult
    }, {})
    let use_play = false
    if (possible_play_names.length == 1) {
      const play_index = parseInt(possible_play_names[0].replace('play', ''))
      use_play = this.available_plays()[play_index]
    } else {
      console.error("more than one possible play:", possible_play_names)
      const play_indicies = possible_play_names.map((play_name) => {
        return parseInt(play_name.replace('play', ''))
      })
      const possible_plays = play_indicies.map((play_index) => {
        this.available_plays()[play_index]
      })

      if (Object.keys(result).length == 1) {
        const swaps_removed = possible_plays.filter((play) => play.destination != 'swap')
        if (swaps_removed.length == 1) {
          use_play = swaps_removed[0]
        } else {
          throw new Error('i removed the swap and there was still multiple plays!')
        }
      }
    }
    console.log('what play could this possibly be?!:', possible_play_names)
    console.log('choose from: ', this.available_plays())
    let play = {
      position: this.position,
      hand: result,
      destination: use_play.destination
    }
    return this.attemptPlay(play)
  }

  attemptPlay(play) {
    this.sheedhet.attemptPlay(play).then(
      (success) => {
        console.log('successfully attempted play')
        if (success) {
          console.log('update state to:', success)
          this.setState(success)
        } else {
          console.log('attempt failed, try an update')
          throw new Error('attemptPlay failed')
        }
      },
      (failure) => {
        console.log('unable to attempt play, try an update...')
      }
    ).catch((error) => {
      console.log('attemptPlay dint work:', error)
      console.log('try an update...')
      this.sheedhet.update().then(
        (success) => {
          console.log('successfuly fetched update:', success)
          this.setState(success)
        },
        (failure) => {
          console.log('failed to get update, now what?')
        }
      )
    })

    // YO WE MAKIN PLAYS NOW, START MANIPULATING STATE!?!?
    // this.setState(x)
  }

  pass_button_label() {
    return this.state.play_pile.length ? 'Pick Up' : 'Pass'
  }

  passButtonHandler(_event) {
    const pass_play = this.available_plays().find((play) => {
      return play.destination == 'in_hand'
    })
    let play = {
      position: this.position,
      hand: pass_play.hand,
      destination: pass_play.destination
    }
    this.attemptPlay(play)

  }

  render() {
    return (
      <form className="game" onSubmit={this.submitPlayHandler}>
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
            <ControllablePlayer
              player={this.self()}
              plays={this.available_plays()}
            />
            {/*
            <button
              type='button'
              onClick={this.passButtonHandler}
            >{this.pass_button_label()}</button> */}
          </div>
      </form>
    )
  }
}
