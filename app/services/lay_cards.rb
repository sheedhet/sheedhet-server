class LayCards < Turn
  ACTION = 'lay_cards'
  VALID_FACES = ['a', '4', '5', '6', '9', 'j', 'q', 'k']

  def execute
    [@from_face_down, @from_face_up, @from_in_hand].each do |pile|
      pile.each do |card|
        @player.remove_from
      end
    end
  end
end
