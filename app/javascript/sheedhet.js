export default class Sheedhet {
  // eventually this will include an auth component
  constructor(game_id, position, host) {
    // console.log(`start sheedhet library: game_id: ${game_id}, position: ${position}, host: ${host}`)
    this.game_id = game_id
    this.position = position
    this.host = host
  }

  uri(path = '') {
    const game_id = this.game_id
    const position = this.position
    return this.host + `/api/games/${game_id}/players/${position}` + path
  }

  attemptPlay(play) {
    const body = { 'play': play }
    let result =  this.putRequest(JSON.stringify(body))
    return result
  }

  updateState() {
    return this.getRequest()
  }

  putRequest(body) {
    return this.request('PUT', body)
  }

  getRequest() {
    return this.request('GET')
  }

  async request(method, body) {
    const config = {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      method: method,
      body: body
    }
    try {
      let response = await fetch(this.uri(), config)
      if (response.ok) {
        let json = await response.json()
        return json
      } else {
        // console.log('server error', response)
        return false
      }
    }
    catch (err) {
      throw Error(err);
    }
  }
}
