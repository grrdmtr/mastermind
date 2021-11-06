class Rules
  def self.show
    puts "

    How to play Mastermind:

    You first choose to be either the code MAKER or code BREAKER.

    The code BREAKER will have maximum 12 turns to decipher the code that the MAKER has created.
    
    The code consists of 4 digits, each digit ranging from 1-8.
    
    Feedback will be given with each entry to show how close the guess was to the hidden code.

    "

    puts "Press ENTER to continue"
    gets.chomp
    
    puts "
    
    When guessing a correct number that is also in the correct position you will get an X
    and if the guess contains a correct number but is not in the correct position, you will get a O.
    The hints do not help to tell you where the correct number is placed.
    
    Good Luck Code Breaker!
    
    "
    puts "Press ENTER to continue"
    gets.chomp
  end
end

class StartGame
  def initialize(maker, rounds)
    Rules.show
    puts "PRESS ENTER TO START THE GAME"
    gets.chomp
    if maker == "BREAKER"
      Player.do_round(Secret.code(maker),rounds)
    elsif maker == "MAKER"
      Computer.do_round(rounds)
    end
  end
end

class Secret
  def self.code(maker)
    @secret_code = Array.new(4) {''}
    if maker == 'BREAKER'
      @secret_code.map! do |key|
        key = rand(1..6)
      end
    elsif maker == 'MAKER'
      @secret_code = Array.new(4) {0}
      puts "Insert 4 digit code, one at a time, with digits between 1 and 6"
      @secret_code.each_with_index do |key, index|
        @secret_code[index] = gets.to_i
        until @secret_code[index].between?(1,6)
          puts "heyo?"
          @secret_code[index] = gets.to_i
        end
        puts "Insert next digit"
      end
    end
    puts "The secret code is ****"
    p @secret_code
    @secret_code
  end
end

class Rounds
  def self.get
    puts "
    HOW MANY ROUNDS DO YOU WANT TO PLAY? (MIN - 6, MAX - 12)"
    @rounds = gets.to_i
    until @rounds.to_i.between?(6,12) || @rounds == 0
      puts "Enter a valid number"
      @rounds = gets.to_i
    end
    if @rounds == 0 
      @rounds = 12
    end
    puts "You will play #{@rounds} rounds"
    @rounds
  end
end

class PlayerChoice
  def self.maker
    puts " 
    Do you want to be code MAKER or code BREAKER? 

    PRESS 1 FOR MAKER, 2 FOR BREAKER (Default 2 - BREAKER)
    "
    @role = gets.chomp
    until @role.to_i.between?(1,2) || @role == ''
      puts "Enter a valid number"
      @role = gets.chomp
    end
    (@role == '1') ? @role = 'MAKER' : @role = "BREAKER"

    puts "The role is set to CODE #{@role}"
    @role
  end
end

class Round
  def self.do(secret_code, guessed_code, rounds)
    @guess_code = guessed_code
    @secret_code = secret_code.join.split('')
    @response = ''
    @round = 0
    @temporary_hold = []
    @guess_code.each_with_index do |k, i|
      if @secret_code[i] == @guess_code[i] && (@temporary_hold.include?([@guess_code[i],'O']))
        next
      elsif @secret_code[i] == @guess_code[i]
        @response += 'X'
        @temporary_hold.push([@guess_code[i],'X'])
        if @secret_code.count(@guess_code[i]) > 1
          @temporary_hold.push([@guess_code[i],'O'])
          @response += 'O'
        end
      elsif @secret_code.join.include?(@guess_code[i]) && (@temporary_hold.include?([@guess_code[i],'X']))
        next
      elsif @secret_code.join.include?(@guess_code[i]) && !(@temporary_hold.include?([@guess_code[i],'O']))
        @response +='O'
        @temporary_hold.push([@guess_code[i],'O'])
      end
    end
    @round += 1
    puts @response.split('').shuffle.join('')
    round = @round
    Winner.check(secret_code, guessed_code, round, rounds)
  end
end

class Winner
  def self.check(secret_code, guessed_code, round, rounds)
    @guess_code = guessed_code
    @secret_code = secret_code
    if @secret_code.join == @guess_code.join
      puts "CONGRATULATIONS!"
    else
      if round <= rounds
        Player.do_round(secret_code, rounds)
      else
        puts "YOU LOST!"
        puts "THE SECRET CODE IS #{@secret_code.join('')}"
      end
    end
  end
end

class Player
  def self.do_round(secret, rounds)
    @rounds = rounds
    name = "BREAKER"
    secret_code = secret
    @guess_code = ''

    puts "Enter your guess"

    until @guess_code.length == 4
      @guess_code = gets.chomp
    end

    @guess_code = @guess_code.split('')
    guessed_code = @guess_code
    Round.do(secret_code, guessed_code, rounds)
  end
end

class Computer
  def self.do_round()
    name = "MAKER"
    code = Secret.code(name)
    @guess_code = ''

    puts "Computer making a guess"
    4.times {@guess_code += rand(1..6).to_s}

    @guess_code = @guess_code.split('')
    check_round()
  end
end

game = StartGame.new(PlayerChoice.maker, Rounds.get)
