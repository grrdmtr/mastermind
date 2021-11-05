class Mastermind

  def initialize()
    show_rules()
    @role = get_role()
    @rounds = get_rounds()
    @secret_code = Array.new(4) {''}
    @secret_code = set_code()
    start_game()
    @response = ''
    @round = 0
    do_round()
  end

  def set_code()
    if @role == 'BREAKER'
      @secret_code.map! do |key|
        key = rand(1..6)
      end
    elsif @role == 'MAKER'
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

  def do_round()
    @guess_code = ''

    if @role == 'BREAKER'
      puts "Enter your guess"
      until @guess_code.length == 4
        @guess_code = gets.chomp
      end
    else
      puts "Computer making a guess"
      4.times {@guess_code += rand(1..6).to_s}
    end 

    @guess_code = @guess_code.split('')
    check_round()
  end

  # def computer_play()
  #   @turns = [[1,1,1,1],[2,2,2,2],[3,3,3,3],[4,4,4,4],[5,5,5,5],[6,6,6,6]]
  #   if @round == 0
  #     @guess_code = @turns[0]
  #   end
  # end 

  def check_round()
    @response = ''
    @round += 1
    @temporary_hold = ''
    @guess_code.each_with_index do |k, i|
        if @secret_code[i].to_s == @guess_code[i]
          @response += 'X'
          @temporary_hold += @guess_code[i]
        elsif @secret_code.join('').include?(@guess_code[i]) && !(@temporary_hold.include?(@guess_code[i]))
          @response +='O'
          @temporary_hold += @guess_code[i]
        end
    end
    puts @response.split('').shuffle.join('')
    if @secret_code.join == @guess_code.join
      puts "CONGRATULATIONS!"
    else
      if @round <= @rounds
        do_round()
      else
        puts "YOU LOST!"
        puts "THE SECRET CODE IS #{@secret_code.join('')}"
      end
    end
  end

  def start_game()
    puts "PRESS ENTER TO START THE GAME"
    gets.chomp
  end

  def get_rounds()
    puts "
    HOW MANY ROUNDS DO YOU WANT TO PLAY? (MIN - 6, MAX - 12)"
    @rounds = gets.to_i
    until @rounds.to_i.between?(6,12) || @rounds == 0
      puts "Enter a valid number"
      @rounds = gets.to_i
    end
    if @rounds == 0 
      @rounds = 6
    end
    puts "You will play #{@rounds} rounds"
    @rounds
  end

  def get_role()
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

  def show_rules()
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

game = Mastermind.new
