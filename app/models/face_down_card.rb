class FaceDownCard
  def suit
    'x'
  end

  def face
    'x'
  end

  def value
    raise 'You shouldnta dun dat'
  end

  def <=>(_other)
    nil
  end

  def as_json
    'xx'
  end
end
