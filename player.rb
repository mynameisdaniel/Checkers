class Player
  
  attr_reader :color
  
  def initialize(color)
    @color = color    
  end

  def gets_move
    begin
      puts "Please select a #{color} piece, eg. 03 = row 0, col 3"
      start_pos = gets.chomp.split("").map(&:to_i)
      puts "Please where the piece will go, eg. 51 = row 5, col 1"
      end_pos = gets.chomp.split("").map(&:to_i)

    raise "Hey! It should be 00-77" unless start_pos.all? { |val| val.between?(0,7) } &&
      end_pos.all? { |val| val.between?(0,7)}
    rescue => e
      puts e.message
      retry
    end
    [start_pos, end_pos]  
  end

  def move
    begin
      puts "Please where you want to jump to, eg. 64 = row 6, col 4"
      end_pos = gets.chomp.split("").map(&:to_i)
      raise "Hey! You need to give a valid spot (00-77)" unless end_pos.all? { |val| val.between?(0,7) }
    rescue => e
      puts e.message
      retry    
    end
    end_pos
  end
end