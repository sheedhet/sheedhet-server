export default class Sheedhet {
  // eventually this will include an auth component
  constructor(game_id, position, host) {
    console.log(`start sheedhet library: game_id: ${game_id}, position: ${position}, host: ${host}`)
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
    const body = { play: play }
    console.log('attempt this request:', body)
    let result = this.putRequest(JSON.stringify(body)).then((good) => {
      console.log('attempted play then: ', good)
      return good
    })
    console.log('returned from attemptPlay:', result)
    return result
  }

  putRequest(body) {
    return this.request('PUT', body)
  }

  getRequest() {
    return this.request('GET')
  }

  request(method, body) {
    const config = {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      method: method,
      body: body
    }
    return fetch(this.uri(), config).then((response) => {
      if (response.ok) {
        return response.json()
      }
      throw new Error(`${response.status}: ${response.statusText}`)
    }).then((data_from_json) => {
      console.log('successful request:', data_from_json)
      return data_from_json
    }).catch((error) => {
      console.log('Error making request:', error)
      return false
    })
  }

  update() {
    console.log('Request update...')
    const result = this.getRequest().then((good) => {
      console.log('i wonder what this is?', good)
      return good
    })
    console.log('returned from update: ', result)
    return result
  }

  failedResponse() {
    // get the new state and do a state update
    console.log('got a failed response, attempting a state update')
    var updated_state = this.update()
    console.log('okay now we have an updated state?')
    return updated_state
  }
}
