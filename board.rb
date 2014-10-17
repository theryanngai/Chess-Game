require 'colorize'
require './pieces.rb'

# move = STDIN.getch
# case move
# when -1
# pos -= 1
# piece.pos[0] += 1

class Board
  attr_reader :grid
  def initialize (populate = true)
    @grid = Array.new(8) { Array.new(8) }
    self.set_pieces if populate
  end
  
  def [](pos)
    @grid[pos[0]][pos[1]]
  end
  
  def []=(pos, value)
    @grid[pos[0]][pos[1]] = value
  end
  
  def display
    # debugger 
    bool = true
    (0..7).each do |row|
      bool = !bool
      puts
      (0..7).each do |col|
        if self[[row, col]].nil?
          print (" " * 2).colorize(:background => :red) if bool
          print (" " * 2).colorize(:background => :white) if !bool
        else
          print (self[[row, col]].uni_string + " ").colorize(:background => :red) if bool
          print (self[[row, col]].uni_string + " ").colorize(:background => :white) if !bool
        end
       bool = !bool
      end
    end
  end
  
  def set_pieces
    set_pawns
  
    rook_pos = [[0, 7], [7, 0], [7, 7], [0, 0]]
    knight_pos = [[0, 1], [0, 6], [7, 1], [7, 6]]
    bishop_pos = [[0, 2], [0, 5], [7, 2], [7, 5]]
    queen_pos = [[7, 3], [0, 3]]
    king_pos = [[0, 4], [7, 4]]
    
    rook_pos.each { |pos| self[pos] = Rook.new(pos, self) }
    knight_pos.each { |pos| self[pos] = Knight.new(pos, self) }
    bishop_pos.each { |pos| self[pos] = Bishop.new(pos, self) }
    king_pos.each { |pos| self[pos] = King.new(pos, self) }
    queen_pos.each { |pos| self[pos] = Queen.new(pos, self) }
    
    # (0..7).each do |row|
#       puts
#       (0..7).each do |col|
#         print self[[row, col]].class
#       end
#     end
    
    set_attributes 
  end
  
  def set_pawns
    pawn_rows = [1, 6]
    pawn_rows.each do |row|
      (0..7).each do |col|
        self[[row, col]] = Pawn.new([row, col], self)
      end
    end
    
  end
  
  def set_attributes
    (0..1).each do |row| 
      (0..7).each do |col|
         set_attributes_helper(self[[row, col]], :white)
      end 
    end
    
    (6..7).each do |row| 
      (0..7).each do |col|
         set_attributes_helper(self[[row, col]], :black)
      end 
    end
  end
  
  def set_attributes_helper(piece, color)
    piece.color = color
    set_uni(piece)
  end
  
  def set_uni(piece)  
     
    if piece.class == Pawn.new.class
      piece.uni_string = "\u2659" if piece.color == :white
      piece.uni_string = "\u265f" if piece.color == :black
    elsif piece.class == Queen.new.class
      piece.uni_string = "\u2655" if piece.color == :white 
      piece.uni_string = "\u265b" if piece.color == :black
    elsif piece.class == King.new.class
      piece.uni_string = "\u2654" if piece.color == :white
      piece.uni_string = "\u265a" if piece.color == :black
    elsif piece.class == Bishop.new.class
      piece.uni_string = "\u2657" if piece.color == :white
      piece.uni_string = "\u265d" if piece.color == :black
    elsif piece.class == Knight.new.class
      piece.uni_string = "\u2658" if piece.color == :white
      piece.uni_string = "\u265e" if piece.color == :black
    elsif piece.class == Rook.new.class
      piece.uni_string = "\u2656" if piece.color == :white
      piece.uni_string = "\u265c" if piece.color == :black
    end
    
  end
  
  def move_piece(from, to, flag)
    if self[from] == nil
      raise ArgumentError.new "There is no piece at the start position"
    end
    
    if flag 
      unless self[from].moves.include?(to)
        raise ArgumentError.new "Piece cannot move there"
      end
    else
      unless self[from].valid_moves.include?(to)
        raise ArgumentError.new "Piece cannot move there"
      end
    end
    
    self[to], self[from] = self[from], nil
    self[to].pos = to
  end
  
  def team(color) #color is what we want returned from this method
    @grid.flatten.compact.select { |piece| piece.color == color } 
  end
  
  def in_check?(color) #color is the team in question
    king = team(color).select { |piece| piece.is_a?(King) }[0]
    color == :black ? color = :white : color = :black
    opponent_pieces = team(color)
    opponent_pieces.each do |piece|
      return true if piece.moves.include?(king.pos)
    end
    
    false
  end
  
  def checkmate?(color) # checks if "color" is in checkmate
    
    if self.in_check?(color)
      team(color).all? { |piece| piece.valid_moves.empty?}
    else
      false
    end
  end
  
  def dup
    dup_board = Board.new(false)
     
    dup_helper(:white, dup_board)
    dup_helper(:black, dup_board)
    
    dup_board
  end
  
  def dup_helper(color, board)
    self.team(color).each do |piece|
      board[piece.pos] = piece.class.new(piece.pos, board)
      board[piece.pos].color = color
    end
  end
  
end






#raise error
# p "hello"
# p b.in_check?(:black)
# b.set_pieces
# wr = Rook.new([3, 3], b)
# wr.color = :white
# br = Rook.new([3, 3], b)
# br.color = :black
# wk = Queen.new([3, 3], b)
# wk.color = :white
# bk = Queen.new([3, 3], b)
# bk.color = :black
# wb = Bishop.new([3, 3], b)
# wb.color = :white
# bb = Bishop.new([3, 3], b)
# bb.color = :black
# p "White Queen"
# p wk.moves
# p "Black Queen"
# p bk.moves
# p "White Rook"
# p wr.moves
# p "Black Rook"
# p br.moves
# p "White Bishop"
# p wb.moves
# p "Black Bishop"
# p bb.moves
# # p b[[0, 0]].class
# # b.display
# # p b.display