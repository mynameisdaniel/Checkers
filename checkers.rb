require './piece'
require './board'
require './player'
require 'colorize'


class Game
  def initialize
    @board = Board.new
    @black_player = Player.new(:black)
    @white_player = Player.new(:white)
    @current_player = @white_player
    play
  end

  def swap_player
    @current_player = @current_player == @white_player ? @black_player : @white_player
  end

  def play
    until @board.game_over? || @board.draw?
      @board.display
      cur_color = @current_player.color
      begin
      moves = @current_player.gets_move
      
      raise "Please select a valid piece" if !@board.valid_piece(moves[0], cur_color)
        
	  if @board.jump_available?(cur_color) &&
        @board.jump_pieces(cur_color).include?(@board.get_spot?(moves[0]))
        new_start = moves[1].dup
  		#make jump
        @board.get_spot?(moves[0]).perform_moves([moves[1]])
        continue(new_start)
      else 
      	#make jump
      	@board.get_spot?(moves[0]).perform_moves([moves[1]])
      end
      swap_player

      rescue => e
      	puts e.message
        retry
      end

    end
  end

  def continue(pos)
  	begin
  	@board.display
    if @board.get_spot?(pos).jump.count > 0
    	puts "You can still jump from #{pos}"
    	new_spot = @current_player.move
    	@board.get_spot?(pos).perform_moves([new_spot.dup])
    	continue(new_spot)
    end
    rescue
    	retry
    end
  end

end


if __FILE__ == $PROGRAM_NAME
  puts "Let's play checkers!"
  Game.new
end