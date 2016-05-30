require_relative 'card'
require_relative 'core_ext/array'

class Hand
  attr_reader :cards
  def initialize(hand)
    @cards = hand.split(" ").map { |card| Card.new card }
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

  def flush?
    @cards.size == 5 && @cards.map(&:type).uniq.size == 1
  end

  def straight?
    @cards.size == 5 && @cards.map(&:rank).number_sequence?
  end

  def full_house?
    three_of_a_kind? && pair?
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
