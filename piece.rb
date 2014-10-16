# encoding: utf-8


class Piece  
  attr_reader :color, :board
  attr_accessor :pos, :king
  
  def initialize(color, pos, board)
    @color = color
    @board = board
    @king = false
    @pos = pos
  end
  
  def direction
    return [[-1, -1], [-1, 1], [1, 1], [1, -1]] if @king
    return [[1, -1], [1, 1]] if color == :black 
    return [[-1, -1], [-1, 1]] if color == :white
  end

  def moves
    returned_moves = []
    direction.each do |delta|
      pos = @pos.dup
      pos[0] += delta[0]
      pos[1] += delta[1]
      returned_moves << pos
    end
    returned_moves.select! do |coord|
      board.valid_pos?(coord) && !board.get_spot?(coord)
      end 
    returned_moves
  end

  def jump
    returned_moves = []
    direction.each do |delta|
      pos = @pos.dup
      pos[0] += delta[0]
      pos[1] += delta[1]
      next if !board.valid_pos?(pos) || board.get_spot?(pos).nil? || 
        board.get_spot?(pos).color == color
      pos[0] += delta[0]
      pos[1] += delta[1]
      returned_moves << pos if board.valid_pos?(pos) && board.get_spot?(pos).nil?  
      end
    returned_moves
  end

  def king?
    @king = true if color == :black && pos[0] == 7
    @king = true if color == :white && pos[0] == 0
  end

  def piece_between(pos1, pos2)
    btw_0 = [pos1[0], pos2[0]].max - 1
    btw_1 = [pos1[1], pos2[1]].max - 1
    [btw_0, btw_1]
  end 

  def perform_jump(pos)
    if jump.include?(pos)
      temp_spot = @pos.dup
      board.move!(@pos, pos)
      set_pos(pos)
      board[piece_between(temp_spot, pos)] = nil
      king?
    else
      raise "Invalid Move!"
    end
  end

  
  def perform_slide(pos)
    if moves.include?(pos)
      board.move!(@pos, pos)
      set_pos(pos)
      king?
    else
      raise "Invalid Move!"
    end
  end

  def perform_moves!(move_sequence)
    begin
    if move_sequence.count == 1
      begin 
        perform_slide(move_sequence.first)
      rescue
        perform_jump(move_sequence.first)
      end
    else
      p move_sequence
      until move_sequence.count == 0
        p move_sequence.first
        perform_jump(move_sequence.shift)
      end
    end
    rescue
      raise "InvalidMoveError"
    end
  end

  def perform_moves(move_sequence)
    return perform_moves!(move_sequence.dup) if valid_move_seq?(move_sequence.dup)  
    raise "InvalidMoveError"
  end

  def valid_move_seq?(move_sequence)
     dupped_board = board.dup
     begin
       dupped_board[@pos].perform_moves!(move_sequence)
       return true
     rescue
       return false
     end
  end

  def set_pos(new_pos)
    @pos = new_pos
  end 

  def inspect
    return "♔" if color == :white && king == true
    return "♚" if color == :black && king == true
    color == :white ? "♙" : "♟"
  end

end
