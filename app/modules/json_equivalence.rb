# module to determine equivalence using json
module JsonEquivalence
  def ==(other)
    other.class == self.class && other.as_json == as_json
  end

  alias eql? ==

  def hash
    as_json.hash
  end
end
