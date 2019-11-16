const PlayAnimator = async (play) => {
  const suit_lookup = {
    'd': 'diamonds',
    'h': 'hearts',
    's': 'spades',
    'c': 'clubs',
  }

  const rank_lookup = {
    'a': 'rank1',
    '2': 'rank2',
    '3': 'rank3',
    '4': 'rank4',
    '5': 'rank5',
    '6': 'rank6',
    '7': 'rank7',
    '8': 'rank8',
    '9': 'rank9',
    '10': 'rank10',
    'j': 'rank11',
    'q': 'rank12',
    'k': 'rank13',
  }
  const self_position = document.querySelector('#sheedhet_container').dataset.position

  const animatePlayPlay = (play) => {
    console.log('PlayAnimator: Regular play detected')

    // Locate target pile elements containing cards to animate
    const target_player_elm = document.querySelector(
      `.player[data-position='${play.position}']`
    )

    // the [].concat trick ensures we have an array
    const face_up_cards_strings = [].concat(play.hand.face_up || [])
    const in_hand_cards_strings = [].concat(play.hand.in_hand || [])

    const face_up_pile_elm = target_player_elm.querySelector('.pile.face_up')
    const in_hand_pile_elm = target_player_elm.querySelector('.pile.in_hand')

    const face_up_cards_selectors = face_up_cards_strings.map((card_string) => {
      const suit = suit_lookup[card_string.slice(-1)]
      const rank = rank_lookup[card_string.slice(0, -1)]
      return `.${suit}.${rank}`
    }).join(',')

    let in_hand_cards_selectors
    if (self_position != play.position) {
      const num_in_hand_cards = in_hand_cards_strings.length
      in_hand_cards_selectors = [
        `.card:nth-child(-n+${num_in_hand_cards})`
      ]
    } else {
      in_hand_cards_selectors = in_hand_cards_strings.map((card_string) => {
        const suit = suit_lookup[card_string.slice(-1)]
        const rank = rank_lookup[card_string.slice(0, -1)]
        return `.${suit}.${rank}`
      }).join(',')
    }

    let face_up_cards_elms = []
    if (face_up_cards_selectors.length > 0) {
      face_up_cards_elms = face_up_pile_elm.querySelectorAll(
        face_up_cards_selectors
      )
    }

    let in_hand_cards_elms = []
    if (in_hand_cards_selectors.length > 0) {
      in_hand_cards_elms = in_hand_pile_elm.querySelectorAll(
        in_hand_cards_selectors
      )
    }

    let playable_cards = []
    if (face_up_cards_strings.length > 0) {
      playable_cards = playable_cards.concat(Array.from(face_up_cards_elms))
    }
    if (in_hand_cards_strings.length > 0) {
      playable_cards = playable_cards.concat(Array.from(in_hand_cards_elms))
    }

    const play_pile = document.querySelector('.pile.play .pile_size_limiter')
    const animation_promises = playable_cards.map( (playable_card_elm) => {
      let card_elm = document.createElement('div')
      card_elm.classList.add('card')
      card_elm.style.opacity = 0
      play_pile.appendChild(card_elm)

      const destination_rect = card_elm.getBoundingClientRect()
      card_elm.remove()
      const promise = animateElmTo(playable_card_elm, destination_rect)

      return promise
    })
    console.log(`animatePlayPlay generated ${animation_promises.length} animations`)
    return Promise.all(animation_promises)
  }

  const animateSwapPlay = (play) => {
    console.log('PlayAnimator: Swap play detected')
    // Identify swapped card strings
    const face_up_cards_strings = play.hand.face_up
    const in_hand_cards_strings = play.hand.in_hand

    // Locate target pile elements containing cards to animate
    const target_player_elm = document.querySelector(
      `.player[data-position='${play.position}']`
    )
    const face_up_pile_elm = target_player_elm.querySelector('.pile.face_up')
    const in_hand_pile_elm = target_player_elm.querySelector('.pile.in_hand')

    // Build selectors to find relevant cards
    const face_up_cards_selectors = face_up_cards_strings.map((card_string) => {
      const suit = suit_lookup[card_string.slice(-1)]
      const rank = rank_lookup[card_string.slice(0, -1)]
      return `.${suit}.${rank}`
    })

    let in_hand_cards_selectors
    if (self_position != play.position) {
      const num_face_up_cards = face_up_cards_strings.length
      in_hand_cards_selectors = [
        `.card:nth-child(-n+${num_face_up_cards})`
      ]
    } else {
      in_hand_cards_selectors = in_hand_cards_strings.map( (card_string) => {
        const suit = suit_lookup[card_string.slice(-1)]
        const rank = rank_lookup[card_string.slice(0, -1)]
        return `.${suit}.${rank}`
      })
    }

    // Locate target card elements
    const face_up_cards_elms = face_up_pile_elm.querySelectorAll(
      face_up_cards_selectors.join(',')
    )
    const in_hand_cards_elms = in_hand_pile_elm.querySelectorAll(
      in_hand_cards_selectors.join(',')
    )
    // Animate each swap
    let animation_promises = []
    Array.from(face_up_cards_elms).forEach( (face_up_card_elm, i) => {
      const in_hand_card_elm = in_hand_cards_elms[i]

      // Get rects
      const face_up_rect = face_up_card_elm.getBoundingClientRect()
      const in_hand_rect = in_hand_card_elm.getBoundingClientRect()

      const promise1 = animateElmTo(face_up_card_elm, in_hand_rect)
      const promise2 = animateElmTo(in_hand_card_elm, face_up_rect)

      animation_promises.push(promise1)
      animation_promises.push(promise2)
    })
    console.log(`animateSwapPlay generated ${animation_promises.length} animations`)
    return Promise.all(animation_promises)
  }

  const animateFlipPlay = (play) => {

  }

  const animatePickupPlay = (play) => {
    console.log('Pickup play detected')
    const play_pile = document.querySelector('.pile.play .pile_size_limiter')
    const play_pile_cards = play_pile.querySelectorAll('.card')
    const target_player_elm = document.querySelector(
      `.player[data-position='${play.position}']`
    )
    const in_hand_pile = target_player_elm.querySelector(
      '.pile.in_hand .pile_size_limiter'
    )

    // move every play_pile card into the destination in_hand
    const animation_promises = Array.from(play_pile_cards).map( (card) => {
      let card_elm = document.createElement('div')
      card_elm.classList.add('card')
      card_elm.style.opacity = 0
      in_hand_pile.appendChild(card_elm)

      const destination_rect = card_elm.getBoundingClientRect()
      const promise = animateElmTo(card, destination_rect)

      return promise
    })
    const false_cards = in_hand_pile.querySelectorAll('div.card')
    false_cards.forEach( (false_card) => { false_card.remove() })
    console.log(`animatePickupPlay generated ${animation_promises.length} animations`)
    return Promise.all(animation_promises)
  }

  const animateElmTo = (origin_elm, destination_rect) => {
    // Create animation completion listener
    const onAnimationComplete = (elm, resolve) => {
      elm.removeEventListener('transitionend', onAnimationComplete)
      elm.style.transform = 'none'
      elm.style.transition = 'unset'
      elm.style.zIndex = 'auto'
      elm.style.transformOrigin = 'unset'
      resolve()
    }

    const origin_rect = origin_elm.getBoundingClientRect()

    // Encapsulate the animation in a Promise and return
    return new Promise((resolve, _reject) => {
      origin_elm.addEventListener(
        'transitionend',
        (_event) => { onAnimationComplete(origin_elm, resolve) }
      )

      // Calculate the difference
      const deltaLeft = destination_rect.left - origin_rect.left
      const deltaTop = destination_rect.top - origin_rect.top
      const deltaWidth = destination_rect.width / origin_rect.width
      const deltaHeight = destination_rect.height / origin_rect.height
      // Animate the change
      origin_elm.style.transformOrigin = 'top left'
      origin_elm.style.transition = 'transform 700ms ease-in-out'
      origin_elm.style.zIndex = 10
      origin_elm.style.transform = `
        translate(${deltaLeft}px, ${deltaTop}px)
        scale(${deltaWidth}, ${deltaHeight})
      `
    })
  }

  const destination = play.destination
  console.log('PlayAnimator: detecting play type')
  switch (destination) {
    case 'swap':
      return animateSwapPlay(play)
      break
    case 'in_hand':
      return animatePickupPlay(play)
      break
    case 'flip0':
    case 'flip1':
    case 'flip2':
    case 'flip3':
      return animateFlipPlay(play)
      break
    case 'play_pile':
      return animatePlayPlay(play)
      break
  }
}
export default PlayAnimator
