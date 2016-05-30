class Card
  attr_reader :suit, :value, :rank

  class InvalidCardError < ArgumentError; end

  PICTURE_CARDS = {J: 11, Q: 12, K:13, A:14}
  VALID_TYPES = ['C'.freeze, 'H'.freeze, 'S'.freeze, 'D'.freeze]

  def initialize(string)
    suit = string[0].upcase
    fail InvalidCardError, 'Invalid card suit' unless VALID_TYPES.include? suit

    @suit = suit
    @value = string[1..-1].upcase
    @rank = typecast_value(@value)
  end

  def to_s
    "#{suit}#{value}"
  end

  private
  def typecast_value(value)
    return value.to_i unless (value =~ /^[2-9]$|^10$/).nil?

    fail InvalidCardError, 'Invalid card value' unless PICTURE_CARDS.has_key? value.to_sym
    PICTURE_CARDS[value.to_sym]
  end
end
