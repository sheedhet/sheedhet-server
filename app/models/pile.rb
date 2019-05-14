require 'json'

# class responsible for individual piles of cards
#
class Pile
  include JsonEquivalence
  extend Direction

  DELEGATE_ARRAY_COMMANDS = %i(each select <<).freeze

  DELGATE_ARRAY_QUERIES = %i(
    all? count include? pop size sort rindex first last sample empty?
    group_by reverse map
  ).freeze

  command DELEGATE_ARRAY_COMMANDS => :@data
  query DELGATE_ARRAY_QUERIES => :@data

  def self.from_json(json_pile, content = Card)
    as_array = JSON.parse(json_pile)
    array_as_json = as_array.map do |json|
      content.from_json(json)
    end
    new(array_as_json, content)
  end

  def self.random(size = 4, content = Card)
    new(Array.new(size) { content.new })
  end

  def initialize(existing = [], content = Card)
    @data = existing
    @content = content
  end

  def as_json
    data.map(&:as_json)
  end

  def -(other)
    raise ArgumentError, "Can't subtract non-Pile" unless other.is_a?(Pile)
    raise ArgumentError, "Can't subtract, #{other.as_json} not in Pile #{self.as_json}" unless contains?(other)
    new_data = data.dup
    other.as_json.each do |card_to_remove|
      remove_from_index = new_data.find_index do |card|
        card.as_json == card_to_remove
      end
      new_data.slice!(remove_from_index)
    end
    Pile.new(new_data)
  end

  def +(other)
    raise ArgumentError, "Can't add non-Pile" unless other.is_a?(Pile)
    new_data = data.dup
    other.as_json.each do |card_to_add|
      new_data.push(@content.from_json(card_to_add))
    end
    Pile.new(new_data)
  end

  def add(card)
    data << card
    self
  end

  def remove(card)
    wrong_class_error_msg = "Can't remove non-#{@content.class}"
    raise ArgumentError, wrong_class_error_msg unless card.is_a?(@content)
    remove_index = data.find_index(card)
    not_found_error_msg = "#{card.class} #{card.as_json} not found"
    raise ArgumentError, not_found_error_msg if remove_index.nil?
    data.slice!(remove_index)
    self
  end

  def group_by_face
    group_by(&:face)
  end

  def turn_down(turned_down: FaceDownCard)
    data.map! { turned_down.new }
  end

  def all
    data
  end

  def contains?(other)
    raise ArgumentError, "Can't compare wtih non-Pile: #{other.class}" unless other.is_a?(Pile)
    grouped_self = group_by(&:as_json)
    grouped_other = other.group_by(&:as_json)
    grouped_other.each do |card, collection|
      card_not_found = grouped_self[card].nil?
      not_enough_of_card = grouped_self[card]&.size&.< collection.size
      return false if card_not_found || not_enough_of_card
    end
    true
  end

  protected

  attr_reader :data
end
