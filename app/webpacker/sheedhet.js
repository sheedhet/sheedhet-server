export default class Sheedhet {
  // eventually this will include an auth component
  constructor (game_id, position, server_url) {
    console.log('new sheedhet, game_id:', game_id)
    this.game_id = game_id
    this.position = position
    this.server_url = server_url
  }

  url () {
    let url = this.server_url
    let game_id = this.game_id
    let position = this.position
    let path = `/api/games/${game_id}/players/${position}`
    return url + path
  }

  attemptPlay (play) {
    console.log('attempt this play:', play)
    let url = this.url()
    let config = {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      method: 'PUT',
      body: JSON.stringify({"play": play})
    }
    console.log('attempt a fetch:', this.url(), config)
    fetch(url, config).then((resp) => {
      if (resp.ok) {
        return resp.json()
      }
      throw new Error()
    }).then((data) => {
      console.log('fetch successful:', data)
      return this.successfulResponse(data)
    }).catch((error) => {
      console.log('catching a failure:', error)
      return this.failedResponse()
    })
  }

  successfulResponse (data) {
    // have the new state, display it
    return data
  }

  update () {
    let url = this.url()
    let config = {
      method: 'GET'
    }
    fetch(url, config).then((resp) => {
      if (resp.ok) {
        return resp.json()
      }
      throw new Error()
    }).then((data) => {
      return data
    }).catch((error) => {
      console.log('boo')
    })
  }

  failedResponse () {
    // get the new state and do a state update
    var updated_state = this.update()
    return updated_state
  }
}
