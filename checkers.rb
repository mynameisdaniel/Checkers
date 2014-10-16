require './piece'
require './board'
require './player'

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
    while @board.pieces(:black).count != 0 || @board.pieces(:black).count != 0
      @board.display
      cur_color = @current_player.color
      begin
      moves = @current_player.gets_move
      
      # error handling, pick a valid piece
      if @board.get_spot?(moves[0]).nil? || @board.get_spot?(moves[0]).color != cur_color
      	raise "Please select your own piece"

      # if jump is availble you must pick a jumping piece
      elsif @board.jump_available?(cur_color) &&
        !@board.jump_pieces(cur_color).include?(@board.get_spot?(moves[0]))
      	raise "You can jump right now, please pick a jumping piece"
      end



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
  	puts "you are in a loop!"
    if @board.get_spot?(pos).jump.count > 0
    	puts "you can still jump from #{pos}"
    	new_spot = @current_player.move

    	print new_spot
    	@board.get_spot?(pos).perform_moves([new_spot.dup])
    	continue(new_spot.dup)
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