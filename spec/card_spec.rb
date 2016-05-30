require_relative 'spec_helper'
require_relative '../lib/card'

describe Card do
  describe 'A new instance' do
    describe 'Without argument' do
      it 'raises InvalidCardError' do
        -> { Card.new }.must_raise ArgumentError
      end
    end

    describe 'With an invalid card type' do
      it 'raises InvalidCardError' do
        (('A'..'Z').to_a - Card::VALID_TYPES).each do |errs, type|
          arg_error = -> { Card.new "#{type}10" }.must_raise Card::InvalidCardError
          arg_error.message.must_equal'Invalid card type'
        end
      end
    end

    describe 'With an invalid card value' do
      it 'raises InvalidCardError' do
        %w(C12 DINVALID H01 S00 C1).each do |card|
          e = -> { Card.new card }.must_raise Card::InvalidCardError
          e.message.must_equal 'Invalid card value'
        end
      end
    end
  end

  describe '#type' do
    let(:club) { Card.new 'C10' }
    let(:diamond) { Card.new 'DJ' }
    let(:heart) { Card.new 'HQ' }
    let(:spade) { Card.new 'S9' }

    it 'gives the type of the card' do
      club.type.must_equal 'C'
    end
  end

  describe '#value' do
    let(:club) { Card.new 'C2' }
    let(:diamond) { Card.new 'Dj' }
    let(:heart) { Card.new 'HQ' }
    let(:spade) { Card.new 'S10' }

    it 'gives the type of the card' do
      club.value.must_equal '2'
      diamond.value.must_equal 'J'
      heart.value.must_equal 'Q'
      spade.value.must_equal '10'
    end
  end

  describe '#rank' do
    let(:club) { Card.new 'C2' }
    let(:diamond) { Card.new 'Dj' }
    let(:heart) { Card.new 'HQ' }
    let(:spade) { Card.new 'S10' }

    it 'gives the type of the card' do
      club.rank.must_equal 2
      diamond.rank.must_equal 11
      heart.rank.must_equal 12
      spade.rank.must_equal 10
    end
  end
end
