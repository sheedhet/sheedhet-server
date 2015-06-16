module JsonEquivalence
  def ==(other)
    other.class == self.class && other.as_json == as_json
  end

  alias_method :eql?, :==

  def hash
    as_json.hash
  end
end
