
class Piece
  attr_accessor :pos, :color, :uni_string
  
  def initialize(pos = nil, board = nil)
    @pos = pos
    @board = board  
  end
  
  def color=(value)
    @color = value
  end
  
  def moves
    puts "Not defined yet"
  end
  
  def move_into_check?(pos)
    dup_board = @board.dup
    dup_board.move_piece(@pos, pos, true)
    dup_board.in_check?(@color)
  end
  
  def valid_moves
    result_moves = []
    self.moves.each do |move|
      result_moves << move unless self.move_into_check?(move)
    end
    
    result_moves
  end
end

class SlidingPiece < Piece
  
  def get_moves(pos, direction)
    moves = []
    range = (0..7).to_a
    direction.each do |dir|
      pos_dup = pos
      loop do
        row, col = pos_dup
        pos_dup = [row + dir[0], col + dir[1]]
        break if !pos_dup.all? { |x| range.include?(x) } 
        break if !@board[pos_dup].nil? && @board[pos_dup].color == self.color
        moves << pos_dup
        break if !@board[pos_dup].nil? && @board[pos_dup].color != self.color
      end
      
    end 
   moves
  end
  
  def moves(direction = :all)
    straight = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    diagonal = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
    return get_moves(@pos, straight) if direction == :straight_line
    return get_moves(@pos, diagonal) if direction == :diagonal
    get_moves(@pos, straight) + get_moves(@pos, diagonal)
  end
  
end

class SteppingPiece < Piece
  def moves(direction = :all)
    knight_dir = [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    king_dir = [[-1, 0], [1, 0], [0, -1], [0, 1], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    return get_moves(@pos, knight_dir) if direction == :knight_dir
    return get_moves(@pos, king_dir) if direction == :king_dir
  end
  
  def get_moves(pos, direction)
    moves = []
    range = (0..7).to_a
    direction.each do |dir|
      pos_dup = pos
      row, col = pos_dup
      pos_dup = [row + dir[0], col + dir[1]]
      next if !pos_dup.all? { |x| range.include?(x) }
      next if !@board[pos_dup].nil? && @board[pos_dup].color == self.color
      moves << pos_dup 
    end
    
    moves 
  end
  
end

class Pawn < Piece
  def moves
    
    # debugger if @pos[0] == 1 && @color == :black || @pos[0] == 6 && @color == :white
    moves = []
    dir = [[1, 0], [2, 0], [1, 1], [1, -1]] #negatives for opposite side
    if self.color == :black
      dir.map! { |pos| pos.map { |coordinate| -coordinate } } 
    end
    if [@pos[0] + dir[2][0], @pos[1] + dir[2][1]].all? { |el| (0..7).include?(el) }
      diagonal1 = @board[[@pos[0] + dir[2][0], @pos[1] + dir[2][1]]]
    else
      diagonal1 = nil
    end
    
    if [@pos[0] + dir[3][0], @pos[1] + dir[3][1]].all? { |el| (0..7).include?(el) }
      diagonal2 = @board[[@pos[0] + dir[3][0], @pos[1] + dir[3][1]]]
    else
      diagonal2 = nil
    end
    
    if [@pos[0] + dir[0][0], @pos[1] + dir[0][1]].all? { |el| (0..7).include?(el) }
      ahead_1 = @board[[@pos[0] + dir[0][0], @pos[1] + dir[0][1]]]
    else
      ahead_1 = 0
    end
    
    if [@pos[0] + dir[1][0], @pos[1] + dir[1][1]].all? { |el| (0..7).include?(el) }
      ahead_2 = @board[[@pos[0] + dir[1][0], @pos[1] + dir[1][1]]]
    else
      ahead_2 = 0
    end

    dir_arr = []
    dir_arr << dir[0] if ahead_1.nil?
    dir_arr << dir[1] if [1, 6].include?(@pos[0]) && ahead_1.nil? && ahead_2.nil?
    dir_arr << dir[2] if diagonal1 != nil && diagonal1.color != self.color 
    dir_arr << dir[3] if diagonal2 != nil && diagonal2.color != self.color

    dir_arr.each { |dir| moves << [dir[0] + @pos[0], dir[1] + @pos[1]] } unless dir_arr.empty?
    
    moves
  end
  
end

class Bishop < SlidingPiece
  def moves
    super(:diagonal)
  end
end

class Queen < SlidingPiece
  def moves
    super
  end
end

class Rook < SlidingPiece
  def moves
    super(:straight_line)
  end
end

class Knight < SteppingPiece
  def moves
    super(:knight_dir)
  end
end

class King < SteppingPiece
  def moves
    super(:king_dir)
  end
end