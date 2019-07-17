import React from 'react'

class Play extends React.Component {
  constructor(props) {
    super(props)
    this.state ={
      play: props.play,
      index: props.index,
    }
  }

  render() {
    return(
      <button
        className={`play`}
        id={this.state.index}
      >
        <span className="description">{`${this.state.play.destination}`}</span>
      </button>
    )
  }
}

export default Play
