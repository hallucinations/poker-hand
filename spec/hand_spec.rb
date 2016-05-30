require_relative 'spec_helper'
require_relative '../lib/card'
require_relative '../lib/hand'

describe Hand do
  describe 'a new instance' do
    describe 'with number of cards is not 5' do
      it 'raises InvalidHandrror' do
        err = -> { Hand.new 'D2 S2 HQ C5' }.must_raise Hand::InvalidHandError
        err.message.must_equal 'A hand must have 5 cards'
      end
    end
  end

  describe '#cards' do
    let (:cards) { %w(C10 DA HJ SQ C9).to_a }
    let(:hand) {Hand.new cards.join(' ')}
    subject { hand.cards }

    it 'contains all cards inputted' do
      subject.each { |card| card.must_be_instance_of Card }
      subject.length.must_equal cards.length
    end
  end

  describe '#royal_flush?' do
    let (:rflush_clubs) { Hand.new 'C10 CJ CQ CK CA' }
    let (:rflush_diamonds) { Hand.new 'D10 DJ DQ DK DA' }
    let (:rflush_hearts) { Hand.new 'H10 HJ HQ HK HA' }
    let (:rflush_spades) { Hand.new 'S10 SJ SQ SK SA' }

    it 'is true when A, K, Q, J, 10, all the same suit' do
      rflush_clubs.royal_flush?.must_equal true
      rflush_diamonds.royal_flush?.must_equal true
      rflush_hearts.royal_flush?.must_equal true
      rflush_spades.royal_flush?.must_equal true
    end

    let (:random_diamonds) { Hand.new 'D2 DK D8 D9 D7' }
    let (:random_types) { Hand.new 'H2 DJ C4 D6 D7' }

    it 'is false when it is not a royal flush' do
      random_diamonds.royal_flush?.must_equal false
      random_types.royal_flush?.must_equal false
    end
  end

  describe '#straight_flush?' do
    let (:sflushc) { Hand.new 'C2 C3 C4 C5 C6' }
    let (:sflushd) { Hand.new 'D6 D7 D8 D9 D10' }
    let (:sflushh) { Hand.new 'H9 H10 HJ HQ HK' }
    let (:sflushs) { Hand.new 'S10 SJ SQ SK SA' }

    it 'is true when five cards in a sequence, all in the same suit' do
      sflushc.straight_flush?.must_equal true
      sflushd.straight_flush?.must_equal true
      sflushh.straight_flush?.must_equal true
      sflushs.straight_flush?.must_equal true
    end

    let (:not_straight_flush) { Hand.new 'S10 SJ S7 SK SA' }

    it 'is false when the hand is not straight flush' do
      not_straight_flush.straight_flush?.must_equal false
    end
  end


  describe '#four_of_a_kind?' do
    let (:foak1) { Hand.new 'C10 D10 H10 S10 DA' }
    let (:foak2) { Hand.new 'DA SA HA SA C2' }

    it 'is true when all four cards of the same rank' do
      foak1.four_of_a_kind?.must_equal true
      foak2.four_of_a_kind?.must_equal true
    end

    let (:random1) { Hand.new 'C10 DJ SQ HK DA' }
    let (:random2) { Hand.new 'H2 DJ D10 D4 C2' }

    it 'is false when there are no four cards of the same kind' do
      random1.four_of_a_kind?.must_equal false
      random2.four_of_a_kind?.must_equal false
    end
  end

  describe '#full_house?' do
    let (:full_house1) { Hand.new 'C10 D10 S10 C2 H2' }
    let (:full_house2) { Hand.new 'DQ SQ HQ S4 C4' }
    let (:full_house3) { Hand.new 'H10 S10 C10 DJ SJ' }
    let (:full_house4) { Hand.new 'SA HA CA H9 C9' }

    it 'is true when there is a three of a kind with a pair' do
      full_house1.full_house?.must_equal true
      full_house2.full_house?.must_equal true
      full_house3.full_house?.must_equal true
      full_house4.full_house?.must_equal true
    end

    let (:miss1) { Hand.new 'C10 CJ CQ SK DA' }
    let (:miss2) { Hand.new 'D2 DJ D10 H4 C2' }
    let (:miss3) { Hand.new 'H10 C2 H7 SJ S2' }

    it 'is false when there no three of a kind and a pair' do
      miss1.full_house?.must_equal false
      miss2.full_house?.must_equal false
      miss3.full_house?.must_equal false
    end
  end

  describe '#flush?' do
    let (:flush_c) { Hand.new 'C2 CQ C10 CJ C7' }
    let (:flush_d) { Hand.new 'D2 DQ D10 DJ D7' }
    let (:flush_h) { Hand.new 'H2 HQ H10 HJ H7' }
    let (:flush_s) { Hand.new 'S2 SQ S10 SJ S7' }

    it 'is true when there is any five cards of the same suit, but not in a sequence' do
      flush_c.flush?.must_equal true
      flush_d.flush?.must_equal true
      flush_h.flush?.must_equal true
      flush_s.flush?.must_equal true
    end

    let (:no_flush1) { Hand.new 'C2 DQ C10 CJ C7' }
    let (:no_flush2) { Hand.new 'D2 DQ S10 HJ D7' }

    it 'is true when there is any five cards of the same suit, but not in a sequence' do
      no_flush1.flush?.must_equal false
      no_flush2.flush?.must_equal false
    end
  end

  describe '#straight?' do
    let (:straight1) { Hand.new 'C2 D3 D4 S5 H6' }
    let (:straight2) { Hand.new 'D10 SJ CQ SK HA' }
    let (:straight3) { Hand.new 'H9 H10 SJ DQ CK' }

    it 'is true when five cards in a sequence, but not of the same suit' do
      straight1.straight?.must_equal true
      straight2.straight?.must_equal true
      straight3.straight?.must_equal true
    end

    let (:no_straight1) { Hand.new 'C2 D3 DJ S5 H6' }
    let (:no_straight2) { Hand.new 'D10 SJ C10 SK HA' }
    let (:no_straight3) { Hand.new 'H9 H2 H7 SJ S2' }

    it 'is false when no five cards in a sequence' do
      no_straight1.straight?.must_equal false
      no_straight2.straight?.must_equal false
      no_straight3.straight?.must_equal false
    end
  end

  describe '#three_of_a_kind?' do
    let (:tok1) { Hand.new 'C2 D2 S2 H5 C6' }

    it 'is true when there are three cards of the same rank' do
      tok1.three_of_a_kind?.must_equal true
    end

    let (:no_tok1) { Hand.new 'C2 D2 S3 H5 C6' }

    it 'is false when there are no three cards of the same rank' do
      no_tok1.three_of_a_kind?.must_equal false
    end
  end

  describe '#two_pair?' do
    let (:tp1) { Hand.new 'C2 D2 S10 H10 C6' }

    it 'is true when there are two different pairs' do
      tp1.two_pair?.must_equal true
    end
    let (:no_tp) { Hand.new 'C2 D2 S10 HJ C6' }

    it 'is false when there are no two different pairs' do
      no_tp.two_pair?.must_equal false
    end
  end

  describe '#pair?' do
    let (:pair1) { Hand.new 'C2 D2 SA H7 C6' }

    it 'is true when there are two cards of the same rank' do
      pair1.pair?.must_equal true
    end

    let (:no_pair) { Hand.new 'C2 D3 SA H7 C6' }

    it 'is false when there are no two cards of the same rank' do
      no_pair.pair?.must_equal false
    end
  end

  describe '#high_card' do
    subject { Hand.new('C2 D2 S10 H7 CA').high_card }

    it 'provides the highest ranked card in the deck' do
      subject.rank.must_equal 14
      subject.suit.must_equal 'C'
      subject.value.must_equal 'A'
    end
  end

  describe '#type' do
    let (:rflush_clubs) { Hand.new 'C10 CJ CQ CK CA' }
    let (:sflushc) { Hand.new 'C2 C3 C4 C5 C6' }
    let (:foak) { Hand.new 'C10 D10 H10 S10 DA' }
    let (:full_house) { Hand.new 'C10 D10 S10 C2 H2' }
    let (:sflushc) { Hand.new 'C2 C3 C4 C5 C6' }
    let (:flush_c) { Hand.new 'C2 CQ C10 CJ C7' }
    let (:straight) { Hand.new 'C2 D3 D4 S5 H6' }
    let (:tok) { Hand.new 'C2 D2 S2 H5 C6' }
    let (:tp) { Hand.new 'C2 D2 S10 H10 C6' }
    let (:pair) { Hand.new 'C2 D2 SA H7 C6' }
    let (:hk) { Hand.new 'C4 D2 SA H7 C6' }

    it 'provides the type of the hand' do
      rflush_clubs.type.must_equal 'Royal flush'
      sflushc.type.must_equal 'Straight flush'
      foak.type.must_equal 'Four of a kind'
      flush_c.type.must_equal 'Flush'
      straight.type.must_equal 'Straight'
      tok.type.must_equal 'Three of a kind'
      tp.type.must_equal 'Two pair'
      pair.type.must_equal 'Pair'
      hk.type.must_equal 'High card'
    end
  end

  describe '#to_s' do
    subject { Hand.new 'C10 CJ CQ CK CA' }
    it 'prints the type and high card of the card in a friendly format' do
      subject.to_s.must_equal 'type: Royal flush, high card: CA'
    end
  end
end
