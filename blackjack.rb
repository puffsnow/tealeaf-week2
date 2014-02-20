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

  def deal_card
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

  def start_turn(deck)
    @hand.clear
    self.pick_card(deck.deal_card)
    self.pick_card(deck.deal_card)
  end

  def print_hand
    cards_str = []
    @hand.each do |card|
      cards_str << card.to_s
    end
    cards_str.join(", ")
  end

  def check_point
    point = 0
    @hand.each do |card|
      if card.value.to_i > 0
        point += card.value.to_i
      elsif card.value == "A"
        point += 11
      else
        point += 10
      end
    end

    @hand.select{|card| card.value == "A"}.count.times do
      point -= 10 if point > 21
    end

    point
  end
end

class Dealer < Person
  def turn(deck)
    self.start_turn(deck)
    while true
      puts "Dealer's cards is " + self.print_hand + " now. Dealer's point is " + self.check_point.to_s
      if self.check_point > 21
        puts "OH! Maybe it's a good news. Dealer is BUSTED!"
        break
      elsif self.check_point == 21
        puts "Oops, Dealer gets BLACKJACK! ;)"
        break
      elsif self.check_point >= 17
        puts "Dealer's turn is over."
        break
      end
      new_card = deck.deal_card
      self.pick_card(new_card)
    end
  end
end

class Player < Person
  def turn(deck)
    self.start_turn(deck)
    while true
      puts @name + ", you have " + self.print_hand + " now. Your point is " + self.check_point.to_s
      if self.check_point > 21
        puts "Oops! Sorry, you BUSTED! ;("
        break
      elsif self.check_point == 21
        puts "Great! Blackjack! :)"
        break
      end
      puts "Now you want: 1)Hit or 2)Stay ?"
      command = gets.chomp.to_i

      if command == 1
        new_card = deck.deal_card
        self.pick_card(new_card)
      else
        break
      end
    end
    puts "Now wait for other players and dealer..."
  end
end

class BlackJack
  attr_accessor :deck

  def initialize
    @players = []
    @dealer = Dealer.new("Dealer")
  end

  def prepare_deck
    @deck = Deck.new(3)
  end

  def result_declare(player, result)
    if result == "win"
      puts "Congratulation! " + player.name + "! You win!!!"
    elsif result == "lose"
      puts "Oh! Sorry, " + player.name + ". You lose ;("
    else
      puts "It's a tie, " + player.name + ". :)"
    end
  end

  def run
    puts "Welcome! How many player want to join this game?"
    @players_num = gets.chomp.to_i

    @players_num.times do |num|
      player_num = num + 1
      puts "What's player" + player_num.to_s + "'s name?"
      name = gets.chomp
      player = Player.new(name)
      @players << player
    end

    while true

      self.prepare_deck

      @players.each do |player|
        player.turn(@deck)
      end

      puts "Now it is dealer's turn:"
      @dealer.turn(@deck)

      @players.each do |player|
        if player.check_point == 21
          self.result_declare(player, "win")
        elsif player.check_point > 21
          self.result_declare(player, "lose")
        elsif @dealer.check_point == 21
          self.result_declare(player, "lose")
        elsif @dealer.check_point > 21
          self.result_declare(player, "win")
        elsif @dealer.check_point > player.check_point
          self.result_declare(player, "lose")
        elsif @dealer.check_point < player.check_point
          self.result_declare(player, "win")
        else
          self.result_declare(player, "tie")
        end
      end
      puts "Nice play! Do you want to play one more time? 1)Yes 2)No"
      command = gets.chomp.to_i

      if command == 2
        puts "Have a nice day, good bye:)"
        break
      end
    end
  end
end

BlackJack.new.run