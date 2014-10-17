require 'byebug'

class Board
  attr_reader :board
  
  def initialize()
    @board = Array.new(8) { Array.new(8) }
    populate
  end
  
  def populate 
    @board[0][1] = Piece.new(:black, [0, 1], self)
    @board[0][3] = Piece.new(:black, [0, 3], self)
    @board[0][5] = Piece.new(:black, [0, 5], self)
    @board[0][7] = Piece.new(:black, [0, 7], self)

    @board[1][0] = Piece.new(:black, [1, 0], self)
    @board[1][2] = Piece.new(:black, [1, 2], self)
    @board[1][4] = Piece.new(:black, [1, 4], self)
    @board[1][6] = Piece.new(:black, [1, 6], self)

    @board[2][1] = Piece.new(:black, [2, 1], self)
    @board[2][3] = Piece.new(:black, [2, 3], self)
    @board[2][5] = Piece.new(:black, [2, 5], self)
    @board[2][7] = Piece.new(:black, [2, 7], self)

    @board[5][0] = Piece.new(:white, [5, 0], self)
    @board[5][2] = Piece.new(:white, [5, 2], self)
    @board[5][4] = Piece.new(:white, [5, 4], self)
    @board[5][6] = Piece.new(:white, [5, 6], self)

    @board[6][1] = Piece.new(:white, [6, 1], self)
    @board[6][3] = Piece.new(:white, [6, 3], self)
    @board[6][5] = Piece.new(:white, [6, 5], self)
    @board[6][7] = Piece.new(:white, [6, 7], self)

    @board[7][0] = Piece.new(:white, [7, 0], self)
    @board[7][2] = Piece.new(:white, [7, 2], self)
    @board[7][4] = Piece.new(:white, [7, 4], self)
    @board[7][6] = Piece.new(:white, [7, 6], self)

  end

  def pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color}
  end

  def jump_available?(color)
    jump_pieces(color).count > 0
  end

  def jump_pieces(color)
    jump_pieces = @board.flatten.compact.select do |piece| 
      piece.color == color && piece.jump.count > 0
    end
    jump_pieces.each { |piece| print "#{piece.jump}"}
    jump_pieces
  end


  def [](pos)
    row, col = pos
    @board[row][col]    
  end

  def []=(pos, piece)
    row, col = pos
    @board[row][col] = piece
  end

  def get_spot?(pos)
    x,y = pos
    @board[x][y]
  end

  def valid_piece(pos, color)
    return false if get_spot?(pos.dup).nil?
    return jump_pieces(color).include?(get_spot?(pos.dup)) if jump_available?(color)
    pieces(color).include?(get_spot?(pos)) 
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def move!(start_pos, end_pos)
    # self[end_pos] = self[start_pos]

    start_row, start_col = start_pos
    end_row, end_col = end_pos
    @board[end_row][end_col] = @board[start_row][start_col]
    @board[end_row][end_col].set_pos(end_pos)
    @board[start_row][start_col] = nil
  end

  def inspect
  end

  def dup
    duped_board = Board.new
    (0..7).each do |row|
      (0..7).each do |col|
        old_spot = @board[row][col]
        if old_spot.nil?
          duped_board.board[row][col] = nil
        else
          duped_board.board[row][col] = 
          (old_spot.class).new(old_spot.color, [row, col], duped_board)
        end
      end
    end
    duped_board
  end

  def game_over?
    pieces(:black).count == 0 || pieces(:white).count == 0
  end

  def draw?
    return false if pieces(:black).any? do |piece| 
      piece.jump.count > 0 || piece.moves.count > 0
      end
    return false if pieces(:white).any? do |piece| 
      piece.jump.count > 0 || piece.moves.count > 0
      end  
    true
  end

  def display
    print "   0  1  2  3  4  5  6  7"
    @board.each_with_index do |row, idx|
      print "\n"
      print "#{idx} "
      row.each_with_index do |piece, r_idx|
        if (idx + r_idx) % 2 == 0
          print " #{piece.inspect} ".colorize(:background => :light_white) unless piece.nil?
          print "   ".colorize(:background => :light_white) if piece.nil?
        else
          print " #{piece.inspect} ".colorize(:background => :light_black) unless piece.nil?
          print "   ".colorize(:background => :light_black) if piece.nil?
        end
      end 
    end
    print "\n"
  end

  def inspect
  end

end
