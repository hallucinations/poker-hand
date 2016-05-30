require_relative 'card'
require_relative 'core_ext/array'

class Hand
  attr_reader :cards

  METHOD_TYPE_MAP = {
    :royal_flush? => 'Royal flush',
    :straight_flush? => 'Straight flush',
    :four_of_a_kind? => 'Four of a kind',
    :full_house? => 'Full house',
    :flush? => 'Flush',
    :straight? => 'Straight',
    :three_of_a_kind? => 'Three of a kind',
    :two_pair? => 'Two pair',
    :pair? => 'Pair',
    :high_card? => 'High card'
  }

  def initialize(hand)
    @cards = hand.split(' ').map { |card| Card.new card }
  end

  def type
    key = METHOD_TYPE_MAP.keys.detect { |method| self.send(method) }
    METHOD_TYPE_MAP[key]
  end

  def to_s
    "type: #{type}, high card: #{high_card}"
  end

  def royal_flush?
    straight_flush? && @cards.map(&:rank).max == Card::PICTURE_CARDS.values.max
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    !find_n_similar_rank(4).empty?
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def flush?
    @cards.size == 5 && @cards.map(&:type).uniq.size == 1
  end

  def straight?
    @cards.size == 5 && @cards.map(&:rank).number_sequence?
  end

  def three_of_a_kind?
    !find_n_similar_rank(3).empty?
  end

  def two_pair?
    find_pairs.keys.size == 2
  end

  def pair?
    find_pairs.keys.size == 1
  end

  def high_card?
    true
  end

  def high_card
    @cards.max_by(&:rank)
  end

  private
  def find_n_similar_rank(number)
    @cards.group_by(&:rank).select { |_key, val| val.size == number }
  end

  def find_pairs
    find_n_similar_rank(2)
  end
end
