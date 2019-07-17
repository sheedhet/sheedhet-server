import React from 'react'

class Play extends React.Component {
  constructor(props) {
    super(props)
    this.state ={
      play: props.play,
      // player: props.player,
      index: props.index,
      getRefForCard: props.getRefForCard,
    }
  }

  render() {
    return(
      <button
        className={`play`}
        type="checkbox"
        id={this.state.index}
      >
        <span className="description">{`${this.state.play.destination}`}</span>
        {this.state.play.cards.map( (card_key) => {
          return(
            <div className={`play_input ${card_key}`} key={card_key} />
          )
        })}
      </button>
    )
  }
}

export default Play
