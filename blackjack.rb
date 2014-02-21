#This is Card class, it has two attribute: 'suit' and 'value'.
#Method--
#to_s: return a string to represent this card. ex. Diamond 5 it will return "D5"
class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    suit_str = case suit
                when "C" then "Club"
                when "D" then "Diamond"
                when "H" then "Heart"
                when "S" then "Spade"
               end
    suit_str + value
  end
end

#This is Deck class, it has one attribute: 'deck', 'deck' is an cards array. In initialize, it create a new deck then shuffle.
#decks_num means how many decks(52 cards) you want to join to make a new deck.
#Method--
#deal_card: pop a card from deck, then return this card.
class Deck
  def initialize(decks_num)
    @deck = []
    suits = ["C", "D", "H", "S"]
    values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    suits.each do |suit|
      values.each do |value|
        card = Card.new(suit, value)
        @deck << card
      end
    end
    @deck = @deck * decks_num
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

#This is Person class, describe the common behavior with Player and Dealer, it has two attribute: 'hand' and 'name'
#Method--
#pick_card: pick the card to hand.
#start_turn: initialize hand when the turn begin, it should clear hand first, then pick 2 card to start the game.
#print_hand: return the string with cards in hand
#check_point: calculate the total in hand, it will find the possible max total but not to be busted.
class Person
  attr_reader :name
  attr_accessor :hand
  def initialize(name)
    @hand = []
    @name = name
  end

  def pick_card(card)
    hand << card
  end

  def start_turn(deck)
    hand.clear
    self.pick_card(deck.deal_card)
    self.pick_card(deck.deal_card)
  end

  def print_hand
    cards_str = []
    hand.each do |card|
      cards_str << card.to_s
    end
    cards_str.join(", ")
  end

  def check_point
    point = 0
    hand.each do |card|
      if card.value.to_i > 0
        point += card.value.to_i
      elsif card.value == "A"
        point += 11
      else
        point += 10
      end
    end

    hand.select{|card| card.value == "A"}.count.times do
      point -= 10 if point > 21
    end

    point
  end
end

#This is Dealer class, inherited from Person. It has it's own turn method.
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

#This is Player class, inherited from Person. It has it's own turn method.
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

#This is Blackjack class, describe the process with the whole game. 
#It has 2 attribute: 'players' is an array store the players.
#'dealer' is the dealer object.
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