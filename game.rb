require './board.rb'
require 'io/console'

class Game
  attr_accessor :board
  def initialize
    @board = Board.new
  end
  
  def play
    flag = true
    player = HumanPlayer.new
    # flag ? @board.checkmate?(:white) : @board.checkmate?(:black)
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      @board.display
      side = (flag ? :white : :black) 
      valid = false
      
      
      begin
        from, to = player.play_turn(flag)
        unless @board.team(side).include?(@board[from])
          raise ArgumentError.new("Can't move your opponent's pieces!")
        end
        
        @board.move_piece(from, to, false)
      rescue ArgumentError => e
        puts "#{e.message}"
        retry
      end
        
      flag = !flag
    end
    flag ? (p "White player won!") : (p "Black player won")
  end
end

class HumanPlayer
  
  def initialize
  end
  
  def play_turn(flag)
    player_name = (flag ? "White" : "Black")
    p "It is #{player_name}'s turn. Which piece would you like to move?"
    pos_from = gets.chomp.scan(/\d/).map!(&:to_i)
    p "Where would you like to move it to?"
    pos_to = gets.chomp.scan(/\d/).map!(&:to_i)
      
    [pos_from, pos_to]
  end
end

Game.new.play

# def pawn_test
#   b = Board.new(false)
#
#   k = King.new([7, 2], b)
#   k.color = :white
#   b[[1, 1]] = k
#
#   p1 = Pawn.new([5, 0], b)
#   p1.color = :black
#   b[[5, 0]] = p1
#
#   p2 = Pawn.new([5, 1], b)
#   p2.color = :black
#   b[[5, 1]] = p2
#
#   p3 = Pawn.new([5, 3], b)
#   p3.color = :black
#   b[[5, 3]] = p3
#
#   p4 = Pawn.new([5, 4], b)
#   p4.color = :black
#   b[[5, 4]] = p4
#
#   r = Rook.new([7, 0], b)
#   r.color = :black
#   b[[7, 0]] = r
#
#   p b.checkmate?(:white)
# end

# b = Board.new(false)
#
# p1 = Pawn.new([5, 4], b)
# p1.color = :white
# b[[5, 4]] = p1
#
# p2 = Pawn.new([6, 3], b)
# p2.color = :black
# b[[6, 3]] = p2
#
# p3 = Pawn.new([6, 5], b)
# p3.color = :black
# b[[6, 5]] = p3
#
# wk = King.new([0, 0], b)
# wk.color = :white
# b[[0, 0]] = wk
#
# bk = King.new([7, 7], b)
# bk.color = :white
# b[[7, 7]] = bk
#
#
# p p1.valid_moves



