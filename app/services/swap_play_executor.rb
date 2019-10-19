class SwapPlayExecutor < PlayExecutor
  def valid?
    play.hand[:face_up].size == play.hand[:in_hand].size && super
  end

  def perform_play
    # mark equal number of cards in hand and face up, swap their positions
    from_face_up = play.hand[:face_up]
    from_in_hand = play.hand[:in_hand]
    from_face_up.each { |c| player.cards.remove_from(target: :face_up, subject: c) }
    from_in_hand.each { |c| player.cards.add_to(target: :face_up, subject: c) }
    from_in_hand.each { |c| player.cards.remove_from(target: :in_hand, subject: c) }
    from_face_up.each { |c| player.cards.add_to(target: :in_hand, subject: c) }
    play
  end
end
