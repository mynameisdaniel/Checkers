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
      begin
      @board.display
      color = @current_player.color
      moves = @current_player.gets_move
      
      raise "Please select a valid piece" unless @board.valid_piece(moves[0].dup, color)
	  if @board.jump_available?(color)
        new_start = moves[1].dup
        @board.get_spot?(moves[0]).perform_moves([moves[1]])
        keep_moving(new_start)
      else 
      	@board.get_spot?(moves[0]).perform_moves([moves[1]])
      end
      swap_player

      rescue => e
      	puts e.message
        retry
      end

      puts "Draw!" if @board.draw?
      puts "Game Over" if @board.game_over?
    end
  end

  def keep_moving(pos)
  	begin
  	@board.display
    if @board.get_spot?(pos).jump.count > 0
    	puts "You can still jump from #{pos}"
    	new_spot = @current_player.move
    	@board.get_spot?(pos).perform_moves([new_spot.dup])
    	keep_moving(new_spot)
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