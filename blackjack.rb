class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    @suit + @value
  end
end

class Deck
  def initialize(decks_num)
    @deck = []
    suits = ["C", "D", "H", "S"]
    values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    decks_num.times do 
      suits.each do |suit|
        values.each do |value|
          card = Card.new(suit, value)
          @deck << card
        end
      end
    end
    @deck.shuffle!
  end

  def draw_card
    @deck.pop
  end

  def to_s
    str = ""
    @deck.each do |card|
      str += card.to_s + "\n"
    end
    str
  end
end

class Person
  attr_reader :name
  attr_accessor :hand
  def initialize(name)
    @hand = []
    @name = name
  end

  def pick_card(card)
    @hand << card
  end

  def turn
  end

  def print_hand
    cards_str = []
    @hand.each do |card|
      cards_str << card.to_s
    end
    cards_str.join(", ")
  end

  def check_point
    a_count = 0
    point = 0
    @hand.each do |card|
      if card.value.to_i > 0
        point += card.value.to_i
      elsif card.value == "A"
        point += 1
        a_count += 1
      else
        point += 10
      end
    end

    a_count.times do
      if point + 10 > 21
        break
      end
      point += 10
    end

    point
  end
end

class Dealer < Person
  def turn(deck)
    self.pick_card(deck.draw_card)
    self.pick_card(deck.draw_card)
    while true
      puts "Dealer's cards is " + self.print_hand + " now. Dealer's point is " + self.check_point.to_s
      if self.check_point > 21
        puts "oops!"
        break
      elsif self.check_point == 21
        puts "Great! Blackjack!"
        break
      elsif self.check_point >= 17
        puts "Dealer's turn is over!"
        break
      end
      self.pick_card(deck.draw_card)
    end
  end
end

class Player < Person
  def turn(deck)
    self.pick_card(deck.draw_card)
    self.pick_card(deck.draw_card)
    while true
      puts @name + ", you have " + self.print_hand + " now. Your point is " + self.check_point.to_s
      if self.check_point > 21
        puts "oops!"
        break
      elsif self.check_point == 21
        puts "Great! Blackjack!"
        break
      end
      puts "Now you want: 1)Hit or 2)Stay ?"
      command = gets.chomp.to_i

      if command == 1
        self.pick_card(deck.draw_card)
      else
        puts "OK..."
        break
      end
    end
  end
end

class BlackJack
  attr_accessor :deck

  def initialize
    @players = []
    @dealer = Dealer.new("Dealer")
    @deck = Deck.new(3)
  end

  def run
    puts "Welcome! How many player want to join this game?"
    @players_num = gets.chomp.to_i

    @players_num.times do |num|
      puts "What's player" + num.to_s + "'s name?"
      name = gets.chomp
      player = Player.new(name)
      @players << player
    end

    @players.each do |player|
      player.turn(@deck)
    end

    puts "Now it is dealer's turn:"
    @dealer.turn(@deck)

    @players.each do |player|
      if player.check_point == 21
        puts "Congratulation! " + player.name + "! You win!!!"
      elsif player.check_point > 21
        puts "Oh! Sorry, " + player.name + ". You lose ;("
      elsif @dealer.check_point == 21
        puts "Oh! Sorry, " + player.name + ". You lose ;("
      elsif @dealer.check_point > 21
        puts "Congratulation! " + player.name + "! You win!!!"
      elsif @dealer.check_point > player.check_point
        puts "Oh! Sorry, " + player.name + ". You lose ;("
      elsif @dealer.check_point < player.check_point
        puts "Congratulation! " + player.name + "! You win!!!"
      else
        puts "It's a tie, " + player.name + ". :)"
      end
    end
    puts "Nice play! Have a good time!"
  end
end


BlackJack.new.run