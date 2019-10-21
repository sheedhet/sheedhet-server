import { useState } from 'react'

const useGameState = (initial_game) => {
  const [discard_pile, setDiscardPile] = useJsonState(initial_game.discard_pile)
  const [draw_pile, setDrawPile] = useJsonState(initial_game.draw_pile)
  const [hand_size, setHandSize] = useState(initial_game.hand_size)
  const [history, setHistory] = useJsonState(initial_game.history)
  const [players, setPlayers] = usePlayersState(initial_game.players)
  const [play_pile, setPlayPile] = useJsonState(initial_game.play_pile)
  const [valid_plays, setValidPlays] = useJsonState(initial_game.valid_plays)
  const game = {
    discard_pile,
    draw_pile,
    hand_size,
    history,
    players,
    play_pile,
    valid_plays
  }

  const gameSetters = {
    'discard_pile': setDiscardPile,
    'draw_pile': setDrawPile,
    'hand_size': setHandSize,
    'history': setHistory,
    'players': setPlayers,
    'play_pile': setPlayPile,
    'valid_plays': setValidPlays
  }

  const setGame = (new_game) => {
    Object.keys(game).forEach((property) => {
      if (new_game[property]) {
        gameSetters[property](new_game[property])
      }
    })
  }
  return [game, setGame]
}
export default useGameState

const usePlayersState = (initial_players) => {
  const players = []
  const setters = []
  initial_players.forEach( (player) => {
    const [player_state, setPlayerState] = usePlayerState(player)
    players[player_state.position] = player_state
    setters[player_state.position] = setPlayerState
  })

  const setPlayers = (new_players) => {
    new_players.forEach( (player) => {
      setters[player.position](player)
    })
  }
  return [players, setPlayers]
}

const usePlayerState = (initial_player) => {
  const [name, setName] = useState(initial_player.name)
  const [position, setPosition] = useState(initial_player.position)
  const [cards, setCards] = useJsonState(initial_player.cards)
  const setPlayer = (new_player) => {
    setName(new_player.name)
    setPosition(new_player.position)
    setCards(new_player.cards)
  }
  const player = { name, position, cards }
  return [player, setPlayer]
}

const useJsonState = (initial_json) => {
  const [json, rawSetJson] = useState(initial_json)
  const setJson = (new_json) => {
    if (JSON.stringify(new_json) !== JSON.stringify(json)) {
      rawSetJson(new_json)
    }
  }
  return [json, setJson]
}
